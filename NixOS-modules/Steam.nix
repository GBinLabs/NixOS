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
        extraCompatPackages = [pkgs.proton-ge-bin];
      };
      gamemode = {
        enable = true;
        settings = {
          general = {
            softrealtime = "auto";
            renice = 10;
          };
        };
        enableRenice = true;
      };
    };
  };
}
