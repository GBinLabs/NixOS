{pkgs, ...}: {
  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font = {
      name = "jetbrains-mono";
      size = 10;
    };

    theme = {
      name = "Nordic";
      package = pkgs.nordic;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 8;
    };
  };
  
  qt = {
    enable = true;
    platformTheme.name = "gtk";
    style = {
      name = "gtk2";
      package = pkgs.qt5.qtbase;
    };
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 6;
    gtk.enable = true;
  };
}
