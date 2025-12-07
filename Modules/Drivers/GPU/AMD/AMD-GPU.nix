{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.GPU-AMD;

  # Auto-detectar GPU AMD
  gpuDevice =
    if cfg.gpuDevicePath != null
    then cfg.gpuDevicePath
    else "/sys/class/drm/card1/device";
in {
  options.GPU-AMD = {
    enable = mkEnableOption "AMD GPU - Modo Performance";

    gpuDevicePath = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Override para GPU (si no es card0)";
    };

    gpuClock = mkOption {
      type = types.str;
      default = "1950";
    };
    gpuVoltage = mkOption {
      type = types.str;
      default = "1150";
    };
    memVoltage = mkOption {
      type = types.str;
      default = "950";
    };
    powerLimit = mkOption {
      type = types.int;
      default = 150;
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
      boot.kernelParams = ["amdgpu.ppfeaturemask=0xffffffff"];
      powerManagement.cpuFreqGovernor = lib.mkForce "performance";
    }

    {
      systemd.services.amdgpu-performance = {
        enable = true;
        description = "RX 5500XT - Modo Performance";
        wantedBy = ["multi-user.target"];
        after = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "gpu-performance" ''
            # AUTO-DETECTAR GPU SI NO EXISTE LA RUTA
            GPU_DEVICE="${gpuDevice}"
            if [ ! -d "$GPU_DEVICE" ]; then
              echo "Buscando GPU AMD..."
              for card in /sys/class/drm/card*/device; do
                if [ -f "$card/uevent" ] && grep -q "AMD" "$card/uevent" 2>/dev/null; then
                  GPU_DEVICE="$card"
                  echo "GPU AMD encontrada: $GPU_DEVICE"
                  break
                fi
              done
            fi

            HWMON_PATH=$(ls -d $GPU_DEVICE/hwmon/hwmon* | head -1)

            # Aplicar configuración
            echo high > $GPU_DEVICE/power_dpm_force_performance_level

            cat > $GPU_DEVICE/pp_od_clk_voltage << EOF
            s 0 300 750
            s 1 1400 900
            s 2 1500 950
            s 3 1600 1000
            s 4 1700 1050
            s 5 1800 1100
            s 6 1900 1150
            s 7 ${cfg.gpuClock} ${cfg.gpuVoltage}
            m 0 300 800
            m 1 1750 ${cfg.memVoltage}
            c
            EOF

            echo ${toString (cfg.powerLimit * 1000000)} > $HWMON_PATH/power1_cap

            # NOTA: ${toString cfg.powerLimit} para convertir entero a string
            echo "[GPU] Performance: ${cfg.gpuClock}MHz @ ${cfg.gpuVoltage}mV, ${toString cfg.powerLimit}W"
          '';
        };
      };

      systemd.tmpfiles.rules = [
        "Z ${gpuDevice} 0660 root wheel - -"
      ];
    }

    {
      environment.sessionVariables = {
        RADV_PERFTEST = "nggc,sam,rt,antilag2";
        VK_INSTANCE_LAYERS = "VK_LAYER_MESA_anti_lag";
        AMDGPU_CS_QUEUE_PRIORITY = "high";
        mesa_glthread = "true";
        AMD_DEBUG = "nongfxbrightness";
      };
    }
  ]);
}
