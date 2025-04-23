{
  config,
  lib,
  ...
}: {
  options = {
    Gamemode.enable = lib.mkEnableOption "Habilitar Gamemode";
  };

  config = lib.mkIf config.Gamemode.enable {
    programs.gamemode = {
      enable = true;
      settings = {};
      enableRenice = true;
    };
  };
}
