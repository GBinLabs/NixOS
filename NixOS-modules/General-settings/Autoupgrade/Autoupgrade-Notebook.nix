{
  config,
  lib,
  ...
}: {
  options = {
    Autoupgrade-Notebook.enable = lib.mkEnableOption "Habilitar Autoupgrade-Notebook";
  };

  config = lib.mkIf config.Autoupgrade-Notebook.enable {
    system.autoUpgrade = {
      enable = true;
      dates = "daily";
      allowReboot = false;
      fixedRandomDelay = true;
      operation = "switch";
      persistent = true;
      flake = "/home/german/.GitHub/NixOS/NixOS#Notebook";
    };
  };
}
