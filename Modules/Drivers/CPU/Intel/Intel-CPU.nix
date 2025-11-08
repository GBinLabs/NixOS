# /etc/nixos/modules/Intel-CPU.nix
{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.CPU-Intel;
in
{
  options.CPU-Intel = {
    enable = mkEnableOption "Intel N4020 - undervolt real con intel-undervolt";
    # Valores seguros por defecto (-50mV es agresivo pero estable para N4020)
    cpuOffset = mkOption { type = types.int; default = -50; };
    gpuOffset = mkOption { type = types.int; default = -50; };
    cacheOffset = mkOption { type = types.int; default = -50; };
  };

  config = mkIf cfg.enable {
    # Drivers y microcode
    hardware.cpu.intel.updateMicrocode = true;
    
    # Governor performance para máxima velocidad
    powerManagement.cpuFreqGovernor = "performance";

    # Thermal daemon para control térmico agresivo
    services.thermald = {
      enable = true;
      configFile = pkgs.writeText "thermald-n4020.conf" ''
        <?xml version="1.0"?>
        <ThermalConfiguration>
          <Platform>
            <Name>Intel-N4020</Name>
            <ProductName>*</ProductName>
            <Preference>PERFORMANCE</Preference>
            <ThermalZones>
              <ThermalZone>
                <Type>cpu</Type>
                <TripPoints>
                  <TripPoint>
                    <SensorType>cpu</SensorType>
                    <Temperature>80000</Temperature>
                    <Type>passive</Type>
                  </TripPoint>
                </TripPoints>
              </ThermalZone>
            </ThermalZones>
          </Platform>
        </ThermalConfiguration>
      '';
    };

    # Paquete oficial de NixOS para undervolt
    environment.systemPackages = with pkgs; [ intel-undervolt ];

    # Configuración de undervolt
    environment.etc."intel-undervolt.conf".text = ''
      undervolt 0 'CPU' ${toString cfg.cpuOffset}
      undervolt 1 'GPU' ${toString cfg.gpuOffset}
      undervolt 2 'CPU Cache' ${toString cfg.cacheOffset}
      undervolt 3 'System Agent' ${toString cfg.cacheOffset}
      undervolt 4 'Analog I/O' ${toString cfg.cacheOffset}
      
      # Limitar TDP a 10W (stock es 6W, esto es conservador)
      power limit long 0 10000 28000
      power limit short 0 15000 28000
    '';

    # Servicio que aplica el undervolt al arrancar
    systemd.services.intel-undervolt-apply = {
      enable = true;
      description = "Aplicar undervolt Intel N4020";
      wantedBy = [ "multi-user.target" ];
      after = [ "thermald.service" ];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.intel-undervolt}/bin/intel-undervolt apply";
      };
    };

    # Parámetros del kernel
    boot.kernelParams = [
      "intel_pstate=active"
      "intel_pstate.hwp_only=1"
    ];

    # Herramientas de monitoreo
    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "intel-status" ''
        echo "=== Intel N4020 Status ==="
        echo "Freq: $(cat /proc/cpuinfo | grep 'cpu MHz' | head -1 | awk '{print $4" MHz"}')"
        echo "Temp: $(sensors 2>/dev/null | grep 'Package id 0' | awk '{print $4}' || echo 'N/A')"
      '')
    ];

    environment.shellAliases = {
      intel-temp = "sensors | grep 'Package id 0'";
      intel-freq = "watch -n 1 'grep MHz /proc/cpuinfo | head -2'";
    };
  };
}
