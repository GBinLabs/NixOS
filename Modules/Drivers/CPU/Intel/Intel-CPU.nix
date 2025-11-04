# Modules/Drivers/CPU/Intel/Intel-CPU.nix
{config, lib, pkgs, ...}: {
  options.CPU-Intel.enable = lib.mkEnableOption "CPU Intel con undervolt";

  config = lib.mkIf config.CPU-Intel.enable {
    hardware.cpu.intel.updateMicrocode = true;

    powerManagement = {
      enable = true;
      cpuFreqGovernor = "schedutil";
    };

    services.thermald = {
      enable = true;
      configFile = pkgs.writeText "thermald.conf" ''
        <?xml version="1.0"?>
        <ThermalConfiguration>
          <Platform>
            <Name>Intel Celeron</Name>
            <ProductName>*</ProductName>
            <Preference>PERFORMANCE</Preference>
            <ThermalZones>
              <ThermalZone>
                <Type>cpu</Type>
                <TripPoints>
                  <TripPoint>
                    <SensorType>cpu</SensorType>
                    <Temperature>75000</Temperature>
                    <Type>passive</Type>
                    <CoolingDevice>
                      <Type>intel_pstate</Type>
                      <SamplingPeriod>5</SamplingPeriod>
                    </CoolingDevice>
                  </TripPoint>
                  <TripPoint>
                    <SensorType>cpu</SensorType>
                    <Temperature>85000</Temperature>
                    <Type>active</Type>
                  </TripPoint>
                </TripPoints>
              </ThermalZone>
            </ThermalZones>
          </Platform>
        </ThermalConfiguration>
      '';
    };

    systemd.services.intel-undervolt = {
      description = "Intel CPU Undervolt agresivo";
      wantedBy = ["multi-user.target"];
      after = ["thermald.service"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "intel-undervolt" ''
          ${pkgs.intel-undervolt}/bin/intel-undervolt apply << EOF
          undervolt 0 'CPU' -75
          undervolt 1 'GPU' -60
          undervolt 2 'CPU Cache' -75
          undervolt 3 'System Agent' -50
          undervolt 4 'Analog I/O' -50
          EOF
          
          # Configurar Intel P-State
          echo 1 > /sys/devices/system/cpu/intel_pstate/no_turbo
          
          for cpu in /sys/devices/system/cpu/cpu*/cpufreq/; do
            echo balance_performance > ''${cpu}energy_performance_preference 2>/dev/null || true
          done
        '';
      };
    };

    boot.kernelParams = [
      "intel_pstate=active"
      "intel_pstate.hwp_only=1"
    ];

    environment.systemPackages = with pkgs; [
      intel-undervolt
      intel-gpu-tools
      powertop
    ];

    environment.etc."intel-undervolt.conf".text = ''
      undervolt 0 'CPU' -75
      undervolt 1 'GPU' -60
      undervolt 2 'CPU Cache' -75
      undervolt 3 'System Agent' -50
      undervolt 4 'Analog I/O' -50
      
      power limit long 1 15000 6000000
      power limit short 1 25000 28000
    '';
  };
}
