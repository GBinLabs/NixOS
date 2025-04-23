{
  config,
  lib,
  ...
}: {
  options = {
    Autoupgrade-Servidor.enable = lib.mkEnableOption "Habilitar Autoupgrade-Servidor";
  };

  config = lib.mkIf config.Autoupgrade-Servidor.enable {
    system.autoUpgrade = {
      enable = true;
      dates = "daily";
      allowReboot = false;
      fixedRandomDelay = true;
      operation = "switch";
      persistent = true;
      flake = "/home/german/.GitHub/NixOS/NixOS#Servidor";
    };
  };
}
