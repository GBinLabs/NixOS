{ pkgs, ... }:

{

  xdg.configFile."MangoHud/MangoHud.conf".source = ./MangoHud.conf;
  
  programs.mangohud = {
    enable = true;
    package = pkgs.mangohud;
    enableSessionWide = true;
  };
}
