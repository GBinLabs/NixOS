{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.GPU-Intel;
  # Auto-detectar GPU Intel
  gpuDevice =
    if cfg.gpuDevicePath != null
    then cfg.gpuDevicePath
    else "/sys/class/drm/card0/device";
in {
  options.GPU-Intel = {
    enable = mkEnableOption "Intel UHD 600 - MODO MAX PERFORMANCE";

    gpuDevicePath = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Override para GPU (si no es card0)";
    };

    maxFreq = mkOption {
      type = types.int;
      default = 650; # Frecuencia STOCK (no reducida)
      description = "Frecuencia máxima (MHz)";
    };

    # Para performance, deshabilitamos RC6
    rc6Level = mkOption {
      type = types.int;
      default = 0; # 0 = OFF (menor latencia)
      description = "RC6 power saving (0=off, 1=on)";
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

      # Parámetros de performance para i915
      boot.kernelParams = [
        "i915.enable_guc=3" # Habilitar GuC/HuC (reduce overhead CPU)
        "i915.enable_fbc=1" # Frame Buffer Compression
        "i915.enable_psr=0" # Desactivar PSR (evita flicker/lag)
        "i915.fastboot=1" # Boot más rápido
        "i915.disable_power_well=0" # Power wells siempre on (menor latencia)
        "i915.enable_dc=0" # Desactivar Display Power Saving
        "i915.disable_lp_ring=1" # Desactivar low power ring
      ];
    }

    {
      systemd.services.intel-gpu-performance = {
        enable = true;
        description = "UHD 600 - Modo Performance";
        wantedBy = ["multi-user.target"];
        after = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "gpu-max-perf" ''
            GPU_DEV="${gpuDevice}"

            # Auto-detectar si la ruta no existe
            if [ ! -d "$GPU_DEV" ]; then
              for card in /sys/class/drm/card*/device; do
                if [ -f "$card/uevent" ] && grep -q "i915" "$card/uevent" 2>/dev/null; then
                  GPU_DEV="$card"
                  echo "GPU Intel encontrada: $GPU_DEV"
                  break
                fi
              done
            fi

            # FORZAR FRECUENCIA MÁXIMA
            echo ${toString cfg.maxFreq} > $GPU_DEV/gt_max_freq_mhz 2>/dev/null || true

            # DESHABILITAR RC6 (menor latencia)
            echo ${toString cfg.rc6Level} > $GPU_DEV/power/rc6_enable 2>/dev/null || true

            # Configurar RPS (Render P-States) para performance
            echo 1 > $GPU_DEV/rps_enabled 2>/dev/null || true

            # Forzar render boost a máximo
            echo ${toString cfg.maxFreq} > $GPU_DEV/gt_boost_freq_mhz 2>/dev/null || true

            # Habilitar execlist (mejor scheduling)
            echo 1 > $GPU_DEV/enable_execlist 2>/dev/null || true

            echo "[GPU] UHD 600 configurada a ${toString cfg.maxFreq}MHz | RC6: ${toString cfg.rc6Level}"
          '';
        };
      };

      # Permisos correctos
      systemd.tmpfiles.rules = [
        "Z ${gpuDevice} 0660 root wheel - -"
        "Z ${gpuDevice}/gt_max_freq_mhz 0660 root wheel - -"
        "Z ${gpuDevice}/power/rc6_enable 0660 root wheel - -"
      ];
    }
  ]);
}
