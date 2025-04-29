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
        package = pkgs.steam.override {
          extraLibraries = pkgs: [pkgs.xorg.libxcb];
          extraPkgs = pkgs:
            with pkgs; [
              xorg.libXcursor
              xorg.libXi
              xorg.libXinerama
              xorg.libXScrnSaver
              libpng
              libpulseaudio
              libvorbis
              stdenv.cc.cc.lib
              libkrb5
              keyutils
              gamescope
              gamescope-wsi
              gamemode
            ];
        };
        extraCompatPackages = [pkgs.proton-ge-bin];
      };
      gamescope = {
        enable = true;
        package = pkgs.gamescope;
        capSysNice = true;
      };
    };
  };
}
