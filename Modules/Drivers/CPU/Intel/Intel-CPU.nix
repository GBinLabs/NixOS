{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.CPU-Intel;
  # Valores configurables
  maxTemp = toString cfg.maxTemp;
  maxFreq = toString cfg.maxFreq;
in
{
  options.CPU-Intel = {
    enable = mkEnableOption "Intel N4020 - control térmico agresivo (sin undervolt)";
    maxTemp = mkOption { type = types.int; default = 75000; description = "Temperatura límite (m°C)"; };
    maxFreq = mkOption { type = types.int; default = 2400; description = "Frecuencia máxima (MHz)"; };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # Microcode + governor conservador
      hardware.cpu.intel.updateMicrocode = true;
      powerManagement.cpuFreqGovernor = "performance";
      # Kernel params para eficiencia
      boot.kernelParams = [
        "intel_pstate=passive"      # Desactivar pstate (usa acpi-cpufreq)
        "processor.max_cstate=2"    # C-states profundos
        "intel_idle.max_cstate=2"
      ];
    }

    {
      # Thermal daemon con límite agresivo
      services.thermald = {
        enable = true;
        configFile = pkgs.writeText "thermald-n4020.conf" ''
          <?xml version="1.0"?>
          <ThermalConfiguration>
            <Platform>
              <Name>N4020</Name>
              <ProductName>*</ProductName>
              <Preference>PERFORMANCE</Preference>
              <ThermalZones>
                <ThermalZone>
                  <Type>cpu</Type>
                  <TripPoints>
                    <TripPoint>
                      <SensorType>cpu</SensorType>
                      <Temperature>${maxTemp}</Temperature>
                      <Type>passive</Type>
                    </TripPoint>
                  </TripPoints>
                </ThermalZone>
              </ThermalZones>
            </Platform>
          </ThermalConfiguration>
        '';
      };

      # Limitar frecuencia máxima (efecto similar a undervolt)
      systemd.services.intel-cpu-limit = {
        enable = true;
        description = "Limitar frecuencia CPU N4020";
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "limit-freq" ''
            for cpu in /sys/devices/system/cpu/cpu*/cpufreq; do
              echo ${maxFreq}000 > ''${cpu}/scaling_max_freq
            done
          '';
        };
      };
    }

    {
      # Herramientas de monitoreo
      environment.systemPackages = with pkgs; [
        lm_sensors
        (writeShellScriptBin "cpu-status" ''
          echo "=== Intel N4020 (Modo Seguro) ==="
          echo "Freq Max: ${maxFreq}MHz (limitado)"
          echo "Actual: $(cat /proc/cpuinfo | grep 'cpu MHz' | head -1 | awk '{print $4}')"
          echo "Temp: $(sensors 2>/dev/null | grep 'Package id 0' | awk '{print $4}' || echo 'N/A')"
        '')
      ];
      environment.shellAliases = {
        cpu-temp = "sensors | grep 'Package id 0'";
        cpu-limit = "cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq | awk '{print \$1/1000\" MHz\"}'";
      };
    }

    {
      warnings = optional cfg.enable
        "CPU-Intel: Modo térmico agresivo (sin undervolt) - ${maxFreq}MHz max";
    }
  ]);
}
