{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.GPU-AMD;

  gpuDevice =
    if cfg.gpuDevicePath != null
    then cfg.gpuDevicePath
    else "/sys/class/drm/card1/device";
in {
  options.GPU-AMD = {
    enable = mkEnableOption "AMD RX 5500XT - Undervolt Máximo Validado";

    gpuDevicePath = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Override para GPU device path si difiere de card1";
    };

    gpuClock = mkOption {
      type = types.str;
      default = "1845";
      description = "Frecuencia máxima validada (MHz)";
    };

    powerLimit = mkOption {
      type = types.int;
      default = 110;
      description = "Límite de potencia optimizado con undervolt (W)";
    };

    voltageStates = mkOption {
      type = types.attrsOf types.str;
      default = {
        s0 = "650";
        s1 = "750";
        s2 = "800";
        s3 = "850";
        s4 = "900";
        s5 = "950";
        s6 = "1000";
        s7 = "1025";
      };
      description = "Curva de voltaje validada para cada estado de frecuencia (mV)";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hardware.graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [mesa mesa-demos vulkan-loader];
        extraPackages32 = with pkgs.pkgsi686Linux; [mesa mesa-demos];
      };
      
      environment.variables."AMD_VULKAN_ICD" = "RADV";
      
      boot.kernelParams = [
        "amdgpu.ppfeaturemask=0xffffffff"
      ];
      
      powerManagement.cpuFreqGovernor = lib.mkForce "schedutil";
    }

    {
      systemd.services.amdgpu-optimized = {
        enable = true;
        description = "RX 5500XT - Undervolt Máximo Optimizado";
        wantedBy = ["multi-user.target"];
        after = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "gpu-optimized" ''
            GPU_DEVICE="${gpuDevice}"
            if [ ! -d "$GPU_DEVICE" ]; then
              for card in /sys/class/drm/card*/device; do
                if [ -f "$card/uevent" ] && grep -q "AMD" "$card/uevent" 2>/dev/null; then
                  GPU_DEVICE="$card"
                  break
                fi
              done
            fi

            HWMON_PATH=$(ls -d $GPU_DEVICE/hwmon/hwmon* | head -1)

            echo "[GPU] Aplicando configuración optimizada de undervolt"

            echo manual > $GPU_DEVICE/power_dpm_force_performance_level

            cat > $GPU_DEVICE/pp_od_clk_voltage << EOF
            s 0 300 ${cfg.voltageStates.s0}
            s 1 1200 ${cfg.voltageStates.s1}
            s 2 1350 ${cfg.voltageStates.s2}
            s 3 1500 ${cfg.voltageStates.s3}
            s 4 1600 ${cfg.voltageStates.s4}
            s 5 1700 ${cfg.voltageStates.s5}
            s 6 1800 ${cfg.voltageStates.s6}
            s 7 ${cfg.gpuClock} ${cfg.voltageStates.s7}
            m 0 300 750
            m 1 1750 800
            c
            EOF

            echo ${toString (cfg.powerLimit * 1000000)} > $HWMON_PATH/power1_cap

            echo "[GPU] Configuración aplicada: Max ${cfg.gpuClock}MHz @ ${cfg.voltageStates.s7}mV | Límite ${toString cfg.powerLimit}W"

            echo auto > $GPU_DEVICE/power_dpm_force_performance_level
          '';
        };
      };

      systemd.tmpfiles.rules = [
        "Z ${gpuDevice} 0660 root wheel - -"
      ];
    }

    {
      environment.sessionVariables = {
        RADV_PERFTEST = "sam";
        mesa_glthread = "true";
      };
    }
  ]);
}
