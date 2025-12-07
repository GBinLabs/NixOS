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
    enable = mkEnableOption "Intel N4020 - Optimización Extrema de Eficiencia";

    pl1Limit = mkOption {
      type = types.int;
      default = 4500;
      description = "Límite de potencia sostenido PL1 en miliwatts (extremo: 4.5W vs 6W nominal)";
    };

    pl2Limit = mkOption {
      type = types.int;
      default = 6000;
      description = "Límite de potencia en ráfaga PL2 en miliwatts (6W vs 10W nominal)";
    };

    maxFreq = mkOption {
      type = types.int;
      default = 2400;
      description = "Frecuencia máxima permitida en MHz (restringida vs 2800 MHz nominal)";
    };

    minFreq = mkOption {
      type = types.int;
      default = 800;
      description = "Frecuencia mínima permitida en MHz (reducida para mayor eficiencia)";
    };

    targetTemp = mkOption {
      type = types.int;
      default = 70000;
      description = "Temperatura objetivo en miligrados Celsius (70°C para operación fresca)";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      hardware.cpu.intel.updateMicrocode = true;

      powerManagement.cpuFreqGovernor = lib.mkForce "schedutil";

      boot.kernelParams = [
        "intel_pstate=active"
        "intel_idle.max_cstate=7"
        "processor.max_cstate=7"
        "intel_pstate.no_hwp=0"
      ];

      boot.kernelModules = ["msr"];
      boot.extraModprobeConfig = "options msr allow_writes=on";
    }

    {
      services.thermald = {
        enable = true;
        configFile = pkgs.writeText "n4020-extreme-efficiency.conf" ''
          <?xml version="1.0"?>
          <ThermalConfiguration>
            <Platform>
              <Name>Intel N4020 Extreme Efficiency</Name>
              <ProductName>*</ProductName>
              <Preference>QUIET</Preference>
              <ThermalZones>
                <ThermalZone>
                  <Type>cpu</Type>
                  <TripPoints>
                    <TripPoint>
                      <SensorType>cpu</SensorType>
                      <Temperature>${toString cfg.targetTemp}</Temperature>
                      <Type>passive</Type>
                      <ControlType>SEQUENTIAL</ControlType>
                      <CoolingDevice>
                        <Type>intel_powerclamp</Type>
                        <SamplingPeriod>5</SamplingPeriod>
                      </CoolingDevice>
                    </TripPoint>
                    <TripPoint>
                      <SensorType>cpu</SensorType>
                      <Temperature>85000</Temperature>
                      <Type>critical</Type>
                    </TripPoint>
                  </TripPoints>
                </ThermalZone>
              </ThermalZones>
            </Platform>
          </ThermalConfiguration>
        '';
      };
    }

    {
      systemd.services.intel-extreme-efficiency = {
        enable = true;
        description = "N4020 - Configuración de Eficiencia Extrema";
        wantedBy = ["multi-user.target"];
        after = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "n4020-extreme" ''
            echo "[CPU] Aplicando configuración de eficiencia extrema para N4020"

            # Establecer límites de potencia agresivos
            if [ -f /sys/class/powercap/intel-rapl/intel-rapl:0/constraint_0_power_limit_uw ]; then
              echo ${toString (cfg.pl1Limit * 1000)} > /sys/class/powercap/intel-rapl/intel-rapl:0/constraint_0_power_limit_uw
              echo "[CPU] PL1 establecido: ${toString cfg.pl1Limit}mW"
            fi

            if [ -f /sys/class/powercap/intel-rapl/intel-rapl:0/constraint_1_power_limit_uw ]; then
              echo ${toString (cfg.pl2Limit * 1000)} > /sys/class/powercap/intel-rapl/intel-rapl:0/constraint_1_power_limit_uw
              echo "[CPU] PL2 establecido: ${toString cfg.pl2Limit}mW"
            fi

            # Configurar frecuencias para todas las CPUs
            for cpu in /sys/devices/system/cpu/cpu*/cpufreq; do
              if [ -d "$cpu" ]; then
                echo powersave > "$cpu/scaling_governor"
                echo ${toString (cfg.minFreq * 1000)} > "$cpu/scaling_min_freq"
                echo ${toString (cfg.maxFreq * 1000)} > "$cpu/scaling_max_freq"

                if [ -f "$cpu/energy_performance_preference" ]; then
                  echo power > "$cpu/energy_performance_preference"
                fi
              fi
            done

            # Habilitar todos los C-states para máxima eficiencia en idle
            for cpu in /sys/devices/system/cpu/cpu*/cpuidle; do
              if [ -d "$cpu" ]; then
                for state in "$cpu"/state*; do
                  if [ -f "$state/disable" ]; then
                    echo 0 > "$state/disable"
                  fi
                done
              fi
            done

            # Habilitar powerclamping agresivo
            if [ -d /sys/devices/virtual/thermal/cooling_device0 ]; then
              echo 0 > /sys/devices/virtual/thermal/cooling_device0/cur_state
            fi

            echo "[CPU] Configuración aplicada: ${toString cfg.minFreq}-${toString cfg.maxFreq}MHz | PL1=${toString cfg.pl1Limit}mW | PL2=${toString cfg.pl2Limit}mW"
            echo "[CPU] Temperatura objetivo: ${toString (cfg.targetTemp / 1000)}°C | Modo: Eficiencia extrema"
          '';
        };
      };
    }

    {
      boot.kernel.sysctl = {
        "kernel.nmi_watchdog" = 0;
        "vm.laptop_mode" = 5;
        "vm.dirty_writeback_centisecs" = 6000;
      };
    }
  ]);
}
