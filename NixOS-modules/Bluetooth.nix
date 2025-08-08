{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    Bluetooth.enable = lib.mkEnableOption "Habilitar Bluetooth";
  };

  config = lib.mkIf config.Bluetooth.enable {
    hardware = {
      bluetooth = {
        enable = true;
        powerOnBoot = false;
        package = pkgs.bluez;
      };
    };
    services.blueman.enable = true;
  };
}
