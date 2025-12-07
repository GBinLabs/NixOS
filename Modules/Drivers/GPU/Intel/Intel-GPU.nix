{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.GPU-Intel;
  
  gpuDevice =
    if cfg.gpuDevicePath != null
    then cfg.gpuDevicePath
    else "/sys/class/drm/card0/device";
in {
  options.GPU-Intel = {
    enable = mkEnableOption "Intel UHD 600 - Optimización Extrema de Eficiencia";

    gpuDevicePath = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Override para GPU device path si difiere de card0";
    };

    maxFreq = mkOption {
      type = types.int;
      default = 550;
      description = "Frecuencia máxima GPU en MHz (reducida vs 650 MHz nominal)";
    };

    minFreq = mkOption {
      type = types.int;
      default = 200;
      description = "Frecuencia mínima GPU en MHz (permite idle profundo)";
    };

    rc6Level = mkOption {
      type = types.int;
      default = 1;
      description = "Nivel RC6 power saving (1 = máximo ahorro)";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          intel-media-driver
          intel-compute-runtime
          intel-vaapi-driver
          libvdpau-va-gl
        ];
        extraPackages32 = with pkgs.pkgsi686Linux; [
          intel-media-driver
        ];
      };

      environment.sessionVariables = {
        LIBVA_DRIVER_NAME = "iHD";
        VDPAU_DRIVER = "va_gl";
      };

      boot.kernelModules = ["i915"];
      boot.initrd.kernelModules = ["i915"];

      boot.kernelParams = [
        "i915.enable_guc=3"
        "i915.enable_fbc=1"
        "i915.enable_psr=2"
        "i915.fastboot=1"
        "i915.disable_power_well=1"
        "i915.enable_dc=2"
        "i915.modeset=1"
        "i915.powersave=1"
      ];
    }

    {
      systemd.services.intel-gpu-extreme-efficiency = {
        enable = true;
        description = "UHD 600 - Configuración de Eficiencia Extrema";
        wantedBy = ["multi-user.target"];
        after = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "gpu-extreme-efficiency" ''
            GPU_DEV="${gpuDevice}"

            if [ ! -d "$GPU_DEV" ]; then
              for card in /sys/class/drm/card*/device; do
                if [ -f "$card/uevent" ] && grep -q "i915" "$card/uevent" 2>/dev/null; then
                  GPU_DEV="$card"
                  break
                fi
              done
            fi

            echo "[GPU] Aplicando configuración de eficiencia extrema para UHD 600"

            # Establecer frecuencias restrictivas
            echo ${toString cfg.minFreq} > "$GPU_DEV/gt_min_freq_mhz" 2>/dev/null || true
            echo ${toString cfg.maxFreq} > "$GPU_DEV/gt_max_freq_mhz" 2>/dev/null || true
            echo ${toString cfg.maxFreq} > "$GPU_DEV/gt_boost_freq_mhz" 2>/dev/null || true

            # Habilitar RC6 máximo para ahorro energético
            echo ${toString cfg.rc6Level} > "$GPU_DEV/power/rc6_enable" 2>/dev/null || true

            # Establecer nivel de power management agresivo
            if [ -f "$GPU_DEV/power/control" ]; then
              echo auto > "$GPU_DEV/power/control"
            fi

            # Deshabilitar boost agresivo en favor de eficiencia
            echo 0 > "$GPU_DEV/rps_enabled" 2>/dev/null || true

            # Panel Self Refresh para reducir consumo de display
            if [ -d /sys/class/drm/card0-eDP-1 ]; then
              echo 1 > /sys/class/drm/card0-eDP-1/enabled 2>/dev/null || true
            fi

            echo "[GPU] Configuración aplicada: ${toString cfg.minFreq}-${toString cfg.maxFreq}MHz | RC6 habilitado | PSR activo"
          '';
        };
      };

      systemd.tmpfiles.rules = [
        "Z ${gpuDevice} 0660 root wheel - -"
        "Z ${gpuDevice}/gt_max_freq_mhz 0660 root wheel - -"
        "Z ${gpuDevice}/gt_min_freq_mhz 0660 root wheel - -"
        "Z ${gpuDevice}/power/rc6_enable 0660 root wheel - -"
        "Z ${gpuDevice}/power/control 0660 root wheel - -"
      ];
    }

    {
      powerManagement.powertop.enable = true;
    }
  ]);
}
