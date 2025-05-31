_: {
  programs.mangohud = {
    enable = true;
    enableSessionWide = false;
  };
  home.file.".config/MangoHud/MangoHud.conf".source = ./MangoHud.conf;
}
