{pkgs, ...}: {
  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font = {
      name = "jetbrains-mono";
      size = 10;
    };

    theme = {
      name = "Andromeda";
      package = pkgs.andromeda-gtk-theme;
    };

    iconTheme = {
      name = "Dracula";
      package = pkgs.dracula-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 8;
    };
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 6;
  };
}
