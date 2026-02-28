{
  config,
  lib,
  pkgs,
  ...
}: {

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop = "${config.home.homeDirectory}/Escritorio";
    documents = "${config.home.homeDirectory}/Documentos";
    download = "${config.home.homeDirectory}/Descargas";
    music = "${config.home.homeDirectory}/Música";
    pictures = "${config.home.homeDirectory}/Imágenes";
    publicShare = "${config.home.homeDirectory}/Público";
    templates = "${config.home.homeDirectory}/Plantillas";
    videos = "${config.home.homeDirectory}/Vídeos";
  };

  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Terminal.desktop"
        "org.gnome.Nautilus.desktop"
      ];
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "appindicatorsupport@rgcjonas.gmail.com"
        "just-perfection-desktop@just-perfection"
        "blur-my-shell@aunetx"
      ];
      disable-user-extensions = false;
    };

    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Graphite-Dark";
      icon-theme = "Tela-black-dark";
      cursor-theme = "Bibata-Modern-Ice";
      cursor-size = 20;

      font-name = "Inter 11";
      document-font-name = "Inter 11";
      monospace-font-name = "JetBrains Mono 10";

      font-antialiasing = "rgba";
      font-hinting = "slight";

      enable-animations = false;
      gtk-enable-primary-paste = false;
    };

    "org/gnome/shell/extensions/user-theme" = {
      name = "Graphite-Dark";
    };

    "org/gnome/shell/extensions/just-perfection" = {
      animation = 3;
      dash-icon-size = 48;
      panel-size = 32;
      workspace-switcher-should-show = false;
      startup-status = 0;
    };

    "org/gnome/shell/extensions/blur-my-shell" = {
      brightness = 0.70;
      sigma = 20;
      dash-opacity = 0.20;
      panel-opacity = 0.20;
    };

    "org/gnome/desktop/input-sources" = {
      sources = [(lib.hm.gvariant.mkTuple ["xkb" "latam"])];
    };

    "org/gnome/mutter" = {
      dynamic-workspaces = false;
      edge-tiling = true;
      experimental-features = ["scale-monitor-framebuffer" "variable-refresh-rate" "xwayland-native-scaling"];
    };

    "org/gnome/gnome-screenshot" = {
      auto-save-directory = "file://${config.home.homeDirectory}/Imágenes/Capturas de pantalla";
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 1;
      button-layout = "appmenu:minimize,maximize,close";
      titlebar-font = "Inter Bold 11";
      focus-mode = "click";
    };

    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      speed = 0.0;
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = true;
      tap-to-click = true;
      click-method = "areas";
      two-finger-scrolling-enabled = true;
    };

    "org/gnome/desktop/privacy" = {
      remember-recent-files = false;
      remove-old-trash-files = true;
      old-files-age = 1;
      remove-old-temp-files = true;
      report-technical-problems = false;
    };

    "org/gnome/desktop/session" = {
      idle-delay = lib.hm.gvariant.mkUint32 300;
    };

    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "suspend";
      sleep-inactive-battery-type = "suspend";
      sleep-inactive-ac-timeout = 900;
      sleep-inactive-battery-timeout = 900;
      power-button-action = "suspend";
    };

    "org/gnome/desktop/screensaver" = {
      lock-enabled = true;
      idle-activation-enabled = true;
      lock-delay = lib.hm.gvariant.mkUint32 0;
    };

    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      search-filter-time-type = "last_modified";
      show-hidden-files = false;
      default-sort-order = "name";
      default-sort-in-reverse-order = false;
    };

    "org/gnome/nautilus/list-view" = {
      use-tree-view = false;
      default-zoom-level = "small";
    };

    "org/gnome/desktop/app-folders" = {
      folder-children = ["Utilidades" "LibreOffice"];
    };

    "org/gnome/desktop/app-folders/folders/Utilidades" = {
      name = "Utilidades";
      translate = true;
      apps = [
        "org.gnome.baobab.desktop"
        "btop.desktop"
        "org.gnome.Settings.desktop"
        "org.gnome.DiskUtility.desktop"
        "org.gnome.TextEditor.desktop"
        "org.gnome.Extensions.desktop"
        "org.gnome.eog.desktop"
        "org.gnome.FileRoller.desktop"
        "org.freedesktop.Piper.desktop"
        "org.gnome.Papers.desktop"
      ];
    };

    "org/gnome/desktop/app-folders/folders/LibreOffice" = {
      name = "LibreOffice";
      translate = true;
      apps = [
        "startcenter.desktop"
        "base.desktop"
        "calc.desktop"
        "draw.desktop"
        "impress.desktop"
        "math.desktop"
        "writer.desktop"
      ];
    };

    "org/gnome/desktop/background" = {
      picture-uri = "file://${config.home.homeDirectory}/Imágenes/Wallpapers/NixOS.png";
      picture-uri-dark = "file://${config.home.homeDirectory}/Imágenes/Wallpapers/NixOS.png";
      picture-options = "zoom";
    };
  };

  programs.gnome-shell = {
    enable = true;
    extensions = [
      {package = pkgs.gnomeExtensions.user-themes;}
      {package = pkgs.gnomeExtensions.appindicator;}
      {package = pkgs.gnomeExtensions.just-perfection;}
      {package = pkgs.gnomeExtensions.blur-my-shell;}
    ];
  };

  home.packages = with pkgs; [
    graphite-gtk-theme
    tela-icon-theme
    bibata-cursors
  ];

  home.language = {
    base = "es_AR.UTF-8";
  };

  fonts.fontconfig.enable = true;

  home.file."Imágenes/Wallpapers/NixOS.png".source = ./Wallpapers/NixOS.png;
}
