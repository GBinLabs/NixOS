# Modules/Drivers/GPU/Intel/Intel-GPU.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    GPU-Intel = {
      enable = lib.mkEnableOption "Habilitar GPU-Intel";

      vaDriver = lib.mkOption {
        type = lib.types.enum ["iHD" "i965" "auto"];
        default = "auto";
        description = "Driver VA-API (iHD para Gen 8+, i965 para Gen <8)";
      };

      enableOptimizations = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Habilitar optimizaciones del kernel";
      };

      powerProfile = lib.mkOption {
        type = lib.types.enum ["performance" "balanced" "powersave"];
        default = "balanced";
        description = "Perfil de energía de GPU";
      };
    };
  };

  config = lib.mkIf config.GPU-Intel.enable {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = with pkgs; [
          # VA-API (UHD 600 = Gen 9.5, usa iHD)
          intel-media-driver # iHD (Gen 8+)
          intel-vaapi-driver # i965 (fallback)

          # Vulkan
          intel-compute-runtime # OpenCL

          # Librerías
          intel-vaapi-driver
          libva-vdpau-driver
          libvdpau-va-gl
        ];

        extraPackages32 = with pkgs.pkgsi686Linux; [
          intel-media-driver
          intel-vaapi-driver
          intel-vaapi-driver
        ];
      };

      intel-gpu-tools.enable = true;
    };

    # Variables de entorno
    environment = {
      sessionVariables = lib.mkMerge [
        {
          # Wayland
          MOZ_ENABLE_WAYLAND = "1";
          NIXOS_OZONE_WL = "1";

          # Intel optimizations
          INTEL_DEBUG = ""; # Vacío = sin debug overhead
        }

        # Driver VA-API
        (lib.mkIf (config.GPU-Intel.vaDriver == "iHD") {
          LIBVA_DRIVER_NAME = "iHD";
        })
        (lib.mkIf (config.GPU-Intel.vaDriver == "i965") {
          LIBVA_DRIVER_NAME = "i965";
        })
      ];

      systemPackages = with pkgs; [
        libva-utils
        vulkan-tools
        mesa-demos
        intel-gpu-tools
      ];
    };

    # Módulos del kernel
    boot = {
      kernelModules = ["i915"];

      kernelParams = lib.mkMerge [
        # Base
        [
          "i915.fastboot=1"
          "i915.enable_guc=3" # GuC + HuC firmware (Gen 9+)
        ]

        # Optimizaciones
        (lib.mkIf config.GPU-Intel.enableOptimizations [
          "i915.enable_fbc=1" # Framebuffer compression
          "i915.enable_psr=2" # Panel Self Refresh (Gen 9+)
          "i915.modeset=1"
        ])

        # Perfil de energía
        (lib.mkIf (config.GPU-Intel.powerProfile == "powersave") [
          "i915.enable_dc=2" # Display C-states
          "i915.disable_power_well=0"
        ])
      ];

      initrd.kernelModules = ["i915"];
    };

    # Gestión de energía de GPU
    systemd.tmpfiles.rules = lib.mkMerge [
      # Performance
      (lib.mkIf (config.GPU-Intel.powerProfile == "performance") [
        "w /sys/class/drm/card0/gt_min_freq_mhz - - - - 300"
        "w /sys/class/drm/card0/gt_max_freq_mhz - - - - 750"
      ])

      # Powersave
      (lib.mkIf (config.GPU-Intel.powerProfile == "powersave") [
        "w /sys/class/drm/card0/gt_min_freq_mhz - - - - 200"
        "w /sys/class/drm/card0/gt_max_freq_mhz - - - - 500"
      ])
    ];
  };
}
