{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.CPU-Intel;
in {
  options.CPU-Intel = {
    enable = mkEnableOption "Intel N4020 - MÁXIMO RENDIMIENTO (no juegos)";

    # Parámetros performance
    targetTemp = mkOption {
      type = types.int;
      default = 85000; # 85°C: antes de throttle
      description = "Temperatura límite performance (m°C)";
    };

    minFreq = mkOption {
      type = types.int;
      default = 2400; # Frecuencia base (no bajar de aquí)
      description = "Frecuencia mínima forzada (MHz)";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # === PERFORMANCE CRUDA ===
      hardware.cpu.intel.updateMicrocode = true;
      powerManagement.cpuFreqGovernor = lib.mkForce "performance";

      boot.kernelParams = [
        "intel_pstate=disable" # Usar acpi-cpufreq (más control)
        "processor.max_cstate=1" # DORMIR ES DE DéBILES
        "intel_idle.max_cstate=1"
        "mitigations=off" # +5% rendimiento medible en Celeron
        "nohz_full=0-1" # Timer tickless en ambos núcleos
        "rcu_nocbs=0-1"
        "intel_iommu=off" # Ahorra ciclos si no usas VMs
      ];
    }

    {
      # === THERMALD PERMISSIVO ===
      services.thermald = {
        enable = true;
        configFile = pkgs.writeText "n4020-performance.conf" ''
          <?xml version="1.0"?>
          <ThermalConfiguration>
            <Platform>
              <Name>Intel N4020 Performance</Name>
              <ProductName>*</ProductName>
              <Preference>PERFORMANCE</Preference>
              <ThermalZones>
                <ThermalZone>
                  <Type>cpu</Type>
                  <TripPoints>
                    <!-- No limitar hasta 85°C -->
                    <TripPoint>
                      <SensorType>cpu</SensorType>
                      <Temperature>${toString cfg.targetTemp}</Temperature>
                      <Type>passive</Type>
                    </TripPoint>
                    <!-- Emergencia: 90°C -->
                    <TripPoint>
                      <SensorType>cpu</SensorType>
                      <Temperature>90000</Temperature>
                      <Type>critical</Type>
                    </TripPoint>
                  </TripPoints>
                </ThermalZone>
              </ThermalZones>
            </Platform>
          </ThermalConfiguration>
        '';
      };

      # === FORZAR FRECUENCIAS ALTAS ===
      systemd.services.intel-cpu-performance = {
        enable = true;
        description = "N4020 - Performance Max";
        wantedBy = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "n4020-max" ''
            echo "Forzando N4020 a máximo rendimiento..."

            # Governor performance + frecuencias máximas
            for cpu in /sys/devices/system/cpu/cpu*/cpufreq; do
              echo performance > ''${cpu}/scaling_governor
              echo ${toString cfg.minFreq}000 > ''${cpu}/scaling_min_freq  # No bajar
              echo 2800000 > ''${cpu}/scaling_max_freq                   # Burst siempre disponible

              # Reducir latencia de transición
              echo 1 > ''${cpu}/scaling_min_freq
            done

            # Desactivar C-states completamente (lag de despertar)
            for cpu in /sys/devices/system/cpu/cpu*/cpuidle; do
              [ -d "$cpu" ] || continue
              echo 1 > "$cpu/state1/disable" 2>/dev/null || true
              echo 1 > "$cpu/state2/disable" 2>/dev/null || true
              echo 1 > "$cpu/state3/disable" 2>/dev/null || true
            done

            echo "[CPU] N4020: Performance mode | Min freq: ${toString cfg.minFreq}MHz | No C-states"
          '';
        };
      };
    }
  ]);
}
