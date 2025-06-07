{
  config,
  lib,
  pkgs,
  ...
}:

{

  dconf.settings = {

    "org/gnome/desktop/background" = {
      picture-uri-dark = "file://${config.home.homeDirectory}/Imágenes/Wallpapers/Astronaut.png";
      picture-uri = "file://${config.home.homeDirectory}/Imágenes/Wallpapers/Astronaut.png";
      picture-options = "zoom";
    };

    # Luz nocturna permanente
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-temperature = lib.hm.gvariant.mkUint32 3500;
      night-light-schedule-automatic = false;
      night-light-schedule-from = 0.0;
      night-light-schedule-to = 23.99;
    };

    # Configuración de energía
    "org/gnome/settings-daemon/plugins/power" = {
      power-saver-profile-on-low-battery = true;
      sleep-inactive-ac-timeout = 3600; # 1 hora conectado
      sleep-inactive-battery-timeout = 1800; # 30 min con batería
    };

    # Interfaz de batería
    "org/gnome/desktop/interface" = {
      show-battery-percentage = true;
    };

    # Notificaciones de energía
    "org/gnome/desktop/notifications" = {
      show-in-lock-screen = true;
    };

    # Un área de trabajo fija
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
    };

    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 1;
      theme = "Adwaita-dark";
    };

    # Modo oscuro
    "org/gnome/desktop/interface" = {
      gtk-theme = "Adwaita-dark";
      color-scheme = "prefer-dark";
    };

    # Configuración de ratón sin aceleración
    "org/gnome/desktop/peripherals/mouse" = {
      accel-profile = "flat";
      speed = 0.0;
    };

    # Configuración de touchpad
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
      click-method = "areas";
      natural-scroll = false;
      two-finger-scrolling-enabled = true;
      edge-scrolling-enabled = false;
      disable-while-typing = true;
      middle-click-emulation = false;
    };

    # Configuración adicional para iconos específicos
    "org/gnome/nautilus/icon-view" = {
      default-zoom-level = "small";
    };

    # Configuración de carpetas de aplicaciones
    "org/gnome/desktop/app-folders" = {
      folder-children = [
        "Office"
        "Utilities"
      ];
    };

    "org/gnome/desktop/app-folders/folders/Utilities" = {
      apps = [
        "org.gnome.baobab.desktop"
        "org.gnome.DiskUtility.desktop"
        "org.gnome.Settings.desktop"
        "org.gnome.Evince.desktop"
        "org.gnome.eog.desktop"
        "org.gnome.Extensions.desktop"
        "org.gnome.FileRoller.desktop"
        "org.freedesktop.Piper.desktop"
        "org.gnome.SystemMonitor.desktop"
        "org.gnome.TextEditor.desktop"
      ];
      name = "Utilidades";
      translate = false;
    };

    "org/gnome/desktop/app-folders/folders/Office" = {
      apps = [
        "base.desktop" # Nombres corregidos para NixOS
        "calc.desktop"
        "draw.desktop"
        "impress.desktop"
        "math.desktop"
        "writer.desktop"
      ];
      name = "Oficina";
      translate = false;
    };

    # Aplicaciones favoritas del dock
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Terminal.desktop"
        "nixos-manual.desktop"
        "org.gnome.Nautilus.desktop"
      ];

      # Configuración de múltiples páginas para organizador de aplicaciones
      app-picker-layout = [ ];
    };

    "org/gnome/desktop/privacy" = {
      # Deshabilitar archivos recientes
      remember-recent-files = false;
      recent-files-max-age = 0;

      # Auto-vaciado de papelera y archivos temporales
      remove-old-trash-files = true;
      remove-old-temp-files = true;
      # IMPORTANTE: Ambos (papelera y temp files) usan la misma configuración de edad
      old-files-age = 1; # 1 día para ambos
    };

  };

  # Extensiones de GNOME Shell para ordenación alfabética
  programs.gnome-shell = {
    enable = true;
    extensions = [
      {
        package = pkgs.gnomeExtensions.alphabetical-app-grid;
        id = "alphabetical-app-grid@stuarthayhurst";
      }
      { package = pkgs.gnomeExtensions.appindicator; }
    ];
  };

  home.file."Imágenes/Wallpapers/Astronaut.png".source = ./Wallpapers/Astronaut.png;

}
