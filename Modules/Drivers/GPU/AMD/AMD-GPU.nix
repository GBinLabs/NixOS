{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.GPU-AMD;
  GPU = "/sys/class/drm/card0/device";
  HWMON = "${GPU}/hwmon/hwmon*";
in {
  options.GPU-AMD = {
    enable = mkEnableOption "AMD RX 5500XT - drivers RADV + undervolt";
    gpuClock = mkOption {
      type = types.str;
      default = "1900";
    };
    gpuVoltage = mkOption {
      type = types.str;
      default = "1120";
    };
    memVoltage = mkOption {
      type = types.str;
      default = "950";
    };
    powerLimit = mkOption {
      type = types.int;
      default = 120;
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [ mesa mesa-demos vulkan-loader ];
      };
      environment.variables."AMD_VULKAN_ICD" = "RADV";
      boot.kernelParams = ["amdgpu.ppfeaturemask=0xffffffff"];
    }

    {
      systemd.services.amdgpu-undervolt = {
        enable = true;
        description = "Undervolt RX 5500XT";
        wantedBy = ["graphical-session.target"];
        after = ["graphical-session.target"];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "gpu-uv" ''
            echo manual > ${GPU}/power_dpm_force_performance_level
            cat > ${GPU}/pp_od_clk_voltage << EOF
            s 0 300 800
            s 1 1350 940
            s 2 1450 970
            s 3 1550 1000
            s 4 1650 1030
            s 5 1750 1060
            s 6 1850 1090
            s 7 ${cfg.gpuClock} ${cfg.gpuVoltage}
            m 0 300 800
            m 1 1750 ${cfg.memVoltage}
            c
            EOF
            echo ${toString (cfg.powerLimit * 1000000)} > ${HWMON}/power1_cap
          '';
        };
      };

      systemd.tmpfiles.rules = [
        "Z ${GPU} 0660 root wheel - -"
        "Z ${HWMON} 0660 root wheel - -"
      ];
    }

    {
      environment.systemPackages = with pkgs; [
        (writeShellScriptBin "gpu-status" ''
          echo "=== RX 5500XT ==="
          echo "Config: ${cfg.gpuClock}MHz @ ${cfg.gpuVoltage}mV / ${cfg.memVoltage}mV"
          echo "GPU: $(grep '*' ${GPU}/pp_dpm_sclk 2>/dev/null || echo 'N/A')"
          echo "Temp: $(cat ${HWMON}/temp1_input 2>/dev/null | awk '{print $1/1000"°C"}' || echo 'N/A')"
        '')
      ];
      environment.shellAliases.gpu-temp = "cat ${HWMON}/temp1_input | awk '{print \$1/1000\"°C\"}'";

      # Variables de entorno para Anti-Lag 2
      environment.sessionVariables = {
        RADV_PERFTEST = "nggc,sam,rt,antilag2";
        VK_INSTANCE_LAYERS = "VK_LAYER_MESA_anti_lag";
      };
    }

    {
      warnings =
        optional cfg.enable
        "GPU-AMD: Undervolt activado (${cfg.gpuClock}MHz @ ${cfg.gpuVoltage}mV) + Anti-Lag 2";
    }
  ]);
}
