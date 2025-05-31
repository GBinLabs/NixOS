{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    Steam.enable = lib.mkEnableOption "Habilitar Steam";
  };

  config = lib.mkIf config.Steam.enable {
    programs = {
      steam = {
        enable = true;
        gamescopeSession.enable = true;
        extraCompatPackages = [pkgs.proton-ge-bin];
      };
    };
  };
}
