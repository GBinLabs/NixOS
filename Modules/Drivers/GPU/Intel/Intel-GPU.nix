# Modules/Drivers/GPU/Intel/Intel-GPU.nix
{config, pkgs, lib, ...}: {
  options.GPU-Intel.enable = lib.mkEnableOption "GPU Intel optimizada";

  config = lib.mkIf config.GPU-Intel.enable {
    hardware.graphics = {
      enable = true;
      extraPackages = with pkgs; [
        intel-media-driver
        intel-compute-runtime
      ];
    };

    environment.sessionVariables = {
      LIBVA_DRIVER_NAME = "iHD";
    };

    boot = {
      kernelModules = ["i915"];
      kernelParams = [
        "i915.enable_guc=3"
        "i915.enable_fbc=1"
        "i915.enable_psr=0"
        "i915.fastboot=1"
      ];
      initrd.kernelModules = ["i915"];
    };

    systemd.services.intel-gpu-optimize = {
      description = "Intel GPU Optimización";
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "intel-gpu-setup" ''
          # Configurar frecuencias (UHD 600: 200-650MHz)
          echo 250 > /sys/class/drm/card0/gt_min_freq_mhz 2>/dev/null || true
          echo 650 > /sys/class/drm/card0/gt_max_freq_mhz 2>/dev/null || true
          echo 600 > /sys/class/drm/card0/gt_boost_freq_mhz 2>/dev/null || true
        '';
      };
    };

    environment.systemPackages = with pkgs; [intel-gpu-tools];
  };
}
