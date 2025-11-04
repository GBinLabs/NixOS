# Modules/Drivers/GPU/Intel/Intel-GPU.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  options.GPU-Intel.enable = lib.mkEnableOption "GPU Intel - Máximo rendimiento";

  config = lib.mkIf config.GPU-Intel.enable {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = with pkgs; [
          intel-media-driver
          intel-vaapi-driver
          intel-compute-runtime
          libva-vdpau-driver
          libvdpau-va-gl
        ];

        extraPackages32 = with pkgs.pkgsi686Linux; [
          intel-media-driver
          intel-vaapi-driver
        ];
      };

      intel-gpu-tools.enable = true;
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      INTEL_DEBUG = "";
    };

    environment.systemPackages = with pkgs; [
      libva-utils
      vulkan-tools
      mesa-demos
      intel-gpu-tools
    ];

    boot = {
      kernelModules = ["i915"];
      
      kernelParams = [
        "i915.fastboot=1"
        "i915.enable_guc=3"
        "i915.enable_fbc=1"
        "i915.enable_psr=0"
        "i915.modeset=1"
        "i915.enable_dc=0"
        "i915.disable_power_well=1"
      ];
      
      initrd.kernelModules = ["i915"];
    };

    systemd.tmpfiles.rules = [
      "w /sys/class/drm/card0/gt_min_freq_mhz - - - - 750"
      "w /sys/class/drm/card0/gt_max_freq_mhz - - - - 750"
      "w /sys/class/drm/card0/gt_boost_freq_mhz - - - - 750"
    ];
  };
}
