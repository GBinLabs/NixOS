{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.GPU-Intel;
  GPU = "/sys/class/drm/card0/device";
in
{
  options.GPU-Intel = {
    enable = mkEnableOption "Intel UHD 600 - undervolt soft + optimización";
    # Frecuencia máxima: stock 650MHz, reducida para undervolt "soft"
    maxFreq = mkOption { type = types.int; default = 550; };
    # RC6: nivel de power saving (1=enabled, 2=deep, 3=deepest)
    rc6Level = mkOption { type = types.int; default = 3; };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [ intel-media-driver intel-compute-runtime ];
      };
      environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";
      
      boot.kernelModules = [ "i915" ];
      boot.initrd.kernelModules = [ "i915" ];
      boot.kernelParams = [
        "i915.enable_guc=0"      # Deshabilitar GuC (no necesario para UHD 600)
        "i915.enable_fbc=1"      # Frame Buffer Compression (ahorro de energía)
        "i915.enable_psr=0"      # Panel Self Refresh (puede causar flickering)
        "i915.fastboot=1"        # Boot más rápido
        "i915.disable_power_well=0" # Mantener power wells habilitados
      ];
    }

    {
      systemd.services.intel-gpu-undervolt = {
        enable = true;
        description = "Intel GPU Undervolt Soft (frecuencia limitada)";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "gpu-undervolt" ''
            # Limitar frecuencia máxima (efecto similar a undervolt)
            echo ${toString cfg.maxFreq} > ${GPU}/gt_max_freq_mhz 2>/dev/null || true
            
            # Configurar RC6 power states (ahorro de energía)
            echo ${toString cfg.rc6Level} > ${GPU}/power/rc6_enable 2>/dev/null || true
            
            # Ajustar render boost (reducir sobrecarga)
            echo 400 > ${GPU}/gt_boost_freq_mhz 2>/dev/null || true
            
            # Habilitar RPS (Render P-States) conservador
            echo 1 > ${GPU}/rps_enabled 2>/dev/null || true
            
            echo "Intel GPU: frecuencia limitada a ${toString cfg.maxFreq}MHz"
          '';
        };
      };

      systemd.tmpfiles.rules = [
        "Z ${GPU} 0660 root wheel - -"
        "Z ${GPU}/gt_max_freq_mhz 0660 root wheel - -"
        "Z ${GPU}/power/rc6_enable 0660 root wheel - -"
      ];
    }

    {
      environment.systemPackages = with pkgs; [
        intel-gpu-tools
        (writeShellScriptBin "gpu-status" ''
          echo "=== Intel UHD 600 ==="
          echo "Freq Max: ${toString cfg.maxFreq}MHz (limitado)"
          echo "Actual: $(cat ${GPU}/gt_cur_freq_mhz 2>/dev/null || echo 'N/A')MHz"
          echo "RC6: $(cat ${GPU}/power/rc6_enable 2>/dev/null || echo 'N/A')"
        '')
      ];
      environment.shellAliases.gpu-temp = "sensors | grep -i 'pkg-temp' | head -1";
    }

    {
      warnings = optional cfg.enable
        "GPU-Intel: Modo undervolt soft activado (${toString cfg.maxFreq}MHz max)";
    }
  ]);
}
