{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    GPU-AMD = {
      enable = lib.mkEnableOption "Habilitar GPU-AMD optimizada";
      
      # Perfil de rendimiento
      performanceProfile = lib.mkOption {
        type = lib.types.enum [ "gaming" "balanced" "quiet" ];
        default = "balanced";
        description = ''
          Perfil de rendimiento:
          - "gaming": Máximo rendimiento (más consumo/calor)
          - "balanced": Balance rendimiento/eficiencia
          - "quiet": Prioriza silencio y bajo consumo
        '';
      };
      
      # Habilitar overclocking/tuning (requiere permisos adicionales)
      enableTuning = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Permitir ajustes de voltaje/frecuencia (útil para overclocking)";
      };
    };
  };

  config = lib.mkIf config.GPU-AMD.enable {
    # ===== Hardware Graphics =====
    hardware = {
      amdgpu = {
        # OpenCL para cómputo (Blender, DaVinci, etc.)
        opencl.enable = true;
        
        # Cargar driver en initrd (arranque más rápido y suave)
        initrd.enable = true;
      };

      graphics = {
        enable = true;
        enable32Bit = true;
        
        # Mesa drivers (RADV para Vulkan, RadeonSI para OpenGL)
        extraPackages = with pkgs; [
          # ROCm para OpenCL/HIP
          rocmPackages.clr.icd
          rocmPackages.clr
          # Codecs de video
          libva
          libva-utils
        ];
        
        extraPackages32 = with pkgs.pkgsi686Linux; [
        ];
      };
    };

    # ===== Variables de entorno =====
    environment = {
      sessionVariables = {
        # === Vulkan: RADV (Mesa) - Recomendado para gaming ===
        AMD_VULKAN_ICD = "RADV";
        
        # === Optimizaciones de RADV ===
        # NGG Culling - mejora rendimiento en RDNA 1/2
        RADV_PERFTEST = "nggc,sam";  # sam = Smart Access Memory (si tu CPU/board lo soporta)
        
        # ⚠️ NUNCA uses RADV_DEBUG en producción - solo para debugging
        # RADV_DEBUG = "nodcc,nohiz";  # ❌ ESTO REDUCE RENDIMIENTO
        
        # === Mesa (OpenGL) ===
        MESA_GLTHREAD = "true";           # Multi-threading en OpenGL
        MESA_DISK_CACHE_SIZE = "4096M";   # Caché de shaders (4GB está bien)
        
        # === Desactivar VSync (para gaming) ===
        # vblank_mode = "0";  # Descomenta si quieres desactivar VSync globalmente
        
        # === Wayland (si usas Hyprland) ===
        WLR_DRM_NO_ATOMIC = "0";  # Habilitar Atomic Modesetting
        WLR_RENDERER = "vulkan";  # Usar Vulkan en Wayland
      };

      # Paquetes útiles
      systemPackages = with pkgs; [
        # Herramientas de monitoreo
        radeontop          # Monitor de GPU en tiempo real
        nvtopPackages.amd  # Monitor estilo htop para AMD
        
        # Info y diagnóstico
        clinfo             # Info de OpenCL
        vulkan-tools       # vulkaninfo
        libva-utils        # vainfo (aceleración de video)
        mesa-demos         # glxinfo, glxgears
        
        # Utilidades AMD (overclock, fan control - si enableTuning = true)
        (lib.mkIf config.GPU-AMD.enableTuning lact)  # GUI para control AMD
      ];
    };

    # ===== Módulos del kernel =====
    boot = {
      # Módulo AMDGPU
      kernelModules = [ "amdgpu" ];
      
      # Parámetros del kernel para AMDGPU (RX 5500 XT = Navi 14)
      kernelParams = lib.mkMerge [
        # Parámetros base
        [
          # DPM (Dynamic Power Management) - esencial para AMD
          "amdgpu.dpm=1"
          
          # GPU Recovery en caso de hang
          "amdgpu.gpu_recovery=1"
          
          # Audio sobre HDMI/DP
          "amdgpu.audio=1"
        ]
        
        # Perfil de potencia según configuración
        (lib.mkIf (config.GPU-AMD.performanceProfile == "gaming") [
          "amdgpu.ppfeaturemask=0xffffffff"  # Todas las features habilitadas
        ])
        
        (lib.mkIf (config.GPU-AMD.performanceProfile == "balanced") [
          "amdgpu.ppfeaturemask=0xffffffff"
        ])
        
        (lib.mkIf (config.GPU-AMD.performanceProfile == "quiet") [
          # Limitar power state máximo para menos ruido/calor
          "amdgpu.ppfeaturemask=0xffffffff"
        ])
      ];
      
      # Cargar temprano en initrd
      initrd.kernelModules = [ "amdgpu" ];
    };

    # ===== Gestión de energía de la GPU =====
    systemd.tmpfiles.rules = lib.mkMerge [
      # Perfil de potencia según configuración
      (lib.mkIf (config.GPU-AMD.performanceProfile == "gaming") [
        # high = Máximo rendimiento
        "w /sys/class/drm/card0/device/power_dpm_force_performance_level - - - - high"
      ])
      
      (lib.mkIf (config.GPU-AMD.performanceProfile == "balanced") [
        # auto = El driver gestiona automáticamente
        "w /sys/class/drm/card0/device/power_dpm_force_performance_level - - - - auto"
      ])
      
      (lib.mkIf (config.GPU-AMD.performanceProfile == "quiet") [
        # low = Menor consumo/ruido
        "w /sys/class/drm/card0/device/power_dpm_force_performance_level - - - - low"
      ])
      
      # Permisos para tuning (si está habilitado)
      (lib.mkIf config.GPU-AMD.enableTuning [
        "w /sys/class/drm/card0/device/hwmon/hwmon*/pwm1_enable - - - - 1"
        "w /sys/class/drm/card0/device/power_dpm_force_performance_level - - - - manual"
      ])
    ];

    # ===== Servicios =====
    services = {
      # LACT (Linux AMDGPU Control Tool) - GUI para control de GPU
      lact = lib.mkIf config.GPU-AMD.enableTuning {
        enable = true;
      };
    };

    # ===== Reglas de udev (permisos para monitoring) =====
    services.udev.extraRules = ''
      # Permitir lectura de sensores AMD a usuarios en grupo video
      KERNEL=="card[0-9]*", SUBSYSTEM=="drm", TAG+="uaccess"
      
      ${lib.optionalString config.GPU-AMD.enableTuning ''
        # Permisos para control de ventiladores y overclock
        KERNEL=="hwmon*", SUBSYSTEM=="hwmon", ATTRS{name}=="amdgpu", MODE="0666"
      ''}
    '';
  };
}
