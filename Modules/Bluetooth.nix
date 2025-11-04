# Modules/Bluetooth.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.Bluetooth.enable = lib.mkEnableOption "Habilitar Bluetooth";

  config = lib.mkIf config.Bluetooth.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = false;
      package = pkgs.bluez;
      
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
          Experimental = true;
          KernelExperimental = true;
          FastConnectable = true;
        };
        Policy.AutoEnable = false;
      };
    };
    
    services.blueman.enable = true;
    
    # Optimizaciones
    systemd.services.bluetooth = {
      serviceConfig = {
        ExecStart = [
          ""
          "${pkgs.bluez}/libexec/bluetooth/bluetoothd --noplugin=sap"
        ];
      };
    };
  };
}
