{
  config,
  lib,
  ...
}: {
  options = {
    Autoupgrade-PC.enable = lib.mkEnableOption "Habilitar Autoupgrade-PC";
  };

  config = lib.mkIf config.Autoupgrade-PC.enable {
    system.autoUpgrade = {
      enable = true;
      dates = "daily";
      allowReboot = false;
      fixedRandomDelay = true;
      operation = "switch";
      persistent = true;
      flake = "/home/german/.GitHub/NixOS/NixOS#PC";
    };
  };
}
