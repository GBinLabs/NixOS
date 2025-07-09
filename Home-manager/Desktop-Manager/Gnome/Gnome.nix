{ config, lib, pkgs, ... }:

{
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Terminal.desktop"
        "nixos-manual.desktop"
        "org.gnome.Nautilus.desktop"
      ];
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
      ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme    = "prefer-dark";
      gtk-theme       = "Yaru-blue-dark";
      icon-theme      = "Yaru-blue-dark";
      cursor-theme    = "Bibata-Modern-Ice";
      cursor-size     = 20;
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "Yaru-dark";
    };
    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.hm.gvariant.mkTuple [ "xkb" "latam" ])
      ];
    };
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces  = 1;
      button-layout   = "appmenu:minimize,maximize,close";
    };
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      speed         = 0;
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll   = true;
      tap-to-click     = true;
      click-method     = "areas";
    };
    "org/gnome/desktop/privacy" = {
      remember-recent-files  = false;
      remove-old-trash-files = true;
      old-files-age          = 1;
      remove-old-temp-files  = true;
    };
    "org/gnome/desktop/session" = {
      idle-delay = 0;
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type      = "nothing";
      sleep-inactive-battery-type = "nothing";
      sleep-inactive-ac-timeout   = 0;
      sleep-inactive-battery-timeout = 0;
    };
    "org/gnome/desktop/screensaver" = {
      lock-enabled           = false;
      idle-activation-enabled = false;
    };
    "org/gnome/desktop/app-folders" = {
      folder-children = [ "Utilidades" "LibreOffice" ];
    };
    "org/gnome/desktop/app-folders/folders/Utilidades" = {
      name      = "Utilidades";
      translate = true;
      apps      = [
        "org.gnome.baobab.desktop"
        "org.gnome.DiskUtility.desktop"
        "org.gnome.FileRoller.desktop"
        "org.gnome.Evince.desktop"
        "org.gnome.Settings.desktop"
        "org.gnome.Extensions.desktop"
        "org.gnome.TextEditor.desktop"
        "org.freedesktop.Piper.desktop"
        "org.gnome.eog.desktop"
      ];
    };
    "org/gnome/desktop/app-folders/folders/LibreOffice" = {
      name      = "LibreOffice";
      translate = true;
      apps      = [
        "writer.desktop"
        "calc.desktop"
        "impress.desktop"
        "draw.desktop"
        "base.desktop"
        "startcenter.desktop"
        "math.desktop"
      ];
    };
    "org/gnome/desktop/background" = {
      picture-uri = "file://${config.home.homeDirectory}/Imágenes/Wallpapers/astronauta-slideshow.xml";
      picture-uri-dark = "file://${config.home.homeDirectory}/Imágenes/Wallpapers/astronauta-slideshow.xml";
      picture-options = "zoom";
    };
    
  };

  programs.gnome-shell = {
    enable     = true;
    extensions = [
      { package = pkgs.gnomeExtensions.user-themes; }
      { package = pkgs.gnomeExtensions.appindicator; }
    ];
  };

  home.packages = with pkgs; [
    yaru-theme
    bibata-cursors
    mpvpaper
  ];

  home.language = {
    base = "es_AR.UTF-8";
  };
  
  home.file."Imágenes/Wallpapers/Astronauta1.png".source = ./Wallpapers/Astronauta1.png;
  home.file."Imágenes/Wallpapers/Astronauta2.png".source = ./Wallpapers/Astronauta2.png;

}
