# Modules/Drivers/GPU/AMD/AMD-GPU.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    GPU-AMD = {
      enable = lib.mkEnableOption "Habilitar GPU-AMD optimizada";

      performanceProfile = lib.mkOption {
        type = lib.types.enum ["gaming" "balanced" "quiet"];
        default = "balanced";
        description = ''
          Perfil de rendimiento:
          - "gaming": Máximo rendimiento (más consumo/calor)
          - "balanced": Balance rendimiento/eficiencia
          - "quiet": Prioriza silencio y bajo consumo
        '';
      };

      enableTuning = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Permitir ajustes de voltaje/frecuencia (overclock)";
      };
    };
  };

  config = lib.mkIf config.GPU-AMD.enable {
    # ===== Hardware Graphics =====
    hardware = {
      amdgpu = {
        opencl.enable = true;
        initrd.enable = true;
      };

      graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = with pkgs; [
          # ROCm para OpenCL/HIP (Blender, DaVinci)
          rocmPackages.clr.icd
          rocmPackages.clr
          # Codecs de video
          libva
          libva-utils
          # AMDVLK (driver Vulkan alternativo - opcional)
          # amdvlk
        ];

        extraPackages32 = with pkgs.pkgsi686Linux; [
          # Solo lo esencial para juegos de 32-bit
        ];
      };
    };

    # ===== Variables de entorno =====
    environment = {
      sessionVariables = {
        # === Vulkan: RADV (Mesa) - ÓPTIMO para RDNA 1 ===
        AMD_VULKAN_ICD = "RADV";

        # === Optimizaciones específicas RX 5500 XT (Navi 14) ===
        RADV_PERFTEST = "nggc,sam,rt"; # NGG Culling + SAM + Ray Tracing

        # Force RDNA 1 optimizations
        RADV_FORCE_FAMILY = "gfx1012"; # Navi 14 = GFX10.1.2

        # === Mesa (OpenGL) ===
        MESA_GLTHREAD = "true";
        MESA_NO_ERROR = "1"; # Skip validation = +5-10% FPS

        # Shader cache grande (importante para gaming)
        MESA_DISK_CACHE_SIZE = "8192M"; # 8GB
        MESA_DISK_CACHE_SINGLE_FILE = "true";
        MESA_DISK_CACHE_DATABASE = "true";

        # === VSync OFF (control por juego/compositor) ===
        vblank_mode = "0";
        __GL_SYNC_TO_VBLANK = "0";

        # === Wayland optimizations ===
        WLR_DRM_NO_ATOMIC = "0"; # Atomic modesetting
        WLR_NO_HARDWARE_CURSORS = "1"; # Fix cursor en juegos
        WLR_RENDERER = "vulkan";

        # === Mesa device selection ===
        MESA_VK_DEVICE_SELECT = "1002:7340"; # RX 5500 XT PCI ID
        MESA_VK_DEVICE_SELECT_FORCE_DEFAULT_DEVICE = "1";
      };

      systemPackages = with pkgs; [
        # Monitoreo
        radeontop
        nvtopPackages.amd

        # Info
        clinfo
        vulkan-tools
        libva-utils
        mesa-demos

        # Control de GPU (si enableTuning = true)
        (lib.mkIf config.GPU-AMD.enableTuning lact)
      ];
    };

    # ===== Módulos del kernel =====
    boot = {
      kernelModules = ["amdgpu"];

      kernelParams = lib.mkMerge [
        # Parámetros base para RX 5500 XT
        [
          "amdgpu.dpm=1" # Dynamic Power Management
          "amdgpu.gpu_recovery=1" # Recovery en caso de hang
          "amdgpu.audio=1" # HDMI/DP audio

          # Optimizaciones RDNA 1
          "amdgpu.dc=1" # Display Core Next
          "amdgpu.ppfeaturemask=0xffffffff" # Todas las features

          # Más agresivo para gaming
          "amdgpu.runpm=0" # Deshabilitar runtime PM (menos latencia)
        ]

        # Perfil gaming
        (lib.mkIf (config.GPU-AMD.performanceProfile == "gaming") [
          "amdgpu.gttsize=8192" # GTT size 8GB (para 4GB VRAM)
        ])

        # Perfil quiet
        (lib.mkIf (config.GPU-AMD.performanceProfile == "quiet") [
          "amdgpu.gttsize=4096"
        ])
      ];

      initrd.kernelModules = ["amdgpu"];
    };

    # ===== Gestión de energía =====
    systemd.tmpfiles.rules = lib.mkMerge [
      # Gaming profile
      (lib.mkIf (config.GPU-AMD.performanceProfile == "gaming") [
        "w /sys/class/drm/card*/device/power_dpm_force_performance_level - - - - high"
      ])

      # Balanced profile
      (lib.mkIf (config.GPU-AMD.performanceProfile == "balanced") [
        "w /sys/class/drm/card*/device/power_dpm_force_performance_level - - - - auto"
      ])

      # Quiet profile
      (lib.mkIf (config.GPU-AMD.performanceProfile == "quiet") [
        "w /sys/class/drm/card*/device/power_dpm_force_performance_level - - - - low"
      ])

      # Permisos para tuning
      (lib.mkIf config.GPU-AMD.enableTuning [
        "w /sys/class/drm/card*/device/hwmon/hwmon*/pwm1_enable - - - - 1"
        "w /sys/class/drm/card*/device/power_dpm_force_performance_level - - - - manual"
      ])
    ];

    # ===== LACT (control de GPU) =====
    services.lact = lib.mkIf config.GPU-AMD.enableTuning {
      enable = true;
    };

    # ===== Reglas udev =====
    services.udev.extraRules = ''
      # Permisos para monitoreo
      KERNEL=="card[0-9]*", SUBSYSTEM=="drm", TAG+="uaccess"

      ${lib.optionalString config.GPU-AMD.enableTuning ''
        # Permisos para overclock
        KERNEL=="hwmon*", SUBSYSTEM=="hwmon", ATTRS{name}=="amdgpu", MODE="0666"
      ''}
    '';
  };
}
