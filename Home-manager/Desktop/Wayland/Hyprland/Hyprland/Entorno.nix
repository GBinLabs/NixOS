# Home-manager/Desktop/Wayland/Hyprland/Hyprland/Entorno.nix
{
  config,
  lib,
  pkgs,
  ...
}:
let
  cursorThemeName = "Bibata-Modern-Ice";
  cursorThemePackage = pkgs.bibata-cursors;
  cursorSize = 24;
in
{
  options.Monitor-PC.enable = lib.mkEnableOption "Monitor PC (HDMI 1080p@75Hz)";
  options.Monitor-Notebook.enable = lib.mkEnableOption "Monitor Notebook (eDP 768p@60Hz)";
  options.Monitor-Netbook.enable = lib.mkEnableOption "Monitor Netbook (eDP 768p@60Hz)";
  config = lib.mkMerge [
    {
      fonts.fontconfig.enable = true;

      gtk = {
        enable = true;
        font = {
          name = "JetBrains Mono";
          size = 10;
        };
        theme = {
          name = "Adwaita-dark";
          package = pkgs.gnome-themes-extra;
        };
        iconTheme = {
          name = "Adwaita";
          package = pkgs.adwaita-icon-theme;
        };
        cursorTheme = {
          name = cursorThemeName;
          package = cursorThemePackage;
          size = cursorSize;
        };
      };

      qt = {
        enable = true;
        platformTheme.name = "gtk4";
        style.name = "adwaita-dark";
      };

      home.pointerCursor = {
        name = cursorThemeName;
        package = cursorThemePackage;
        size = cursorSize;
        gtk.enable = true;
        x11 = {
          enable = true;
          defaultCursor = cursorThemeName;
        };
      };

      home.sessionVariables = {
        XDG_CURRENT_DESKTOP = "Hyprland";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "Hyprland";

        QT_QPA_PLATFORMTHEME = "gtk4";
        QT_QPA_PLATFORM = "wayland";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

        GTK_THEME = "Adwaita-dark";
        GDK_BACKEND = "wayland";

        NIXOS_OZONE_WL = "1";

        MOZ_ENABLE_WAYLAND = "1";
        MOZ_WAYLAND_USE_VAAPI = "1";
        MOZ_DBUS_REMOTE = "1";

        SDL_VIDEODRIVER = "wayland";
        SDL_AUDIODRIVER = "pipewire";

        _JAVA_AWT_WM_NONREPARENTING = "1";
        GLFW_PLATFORM = "wayland";

        LANG = "es_AR.UTF-8";
        LC_ALL = "es_AR.UTF-8";
      };

      xdg.userDirs = {
        enable = true;
        documents = "$HOME/Documentos";
        download = "$HOME/Descargas";
        music = "$HOME/Música";
        pictures = "$HOME/Imágenes";
        videos = "$HOME/Vídeos";
      };
    }

    (lib.mkIf config.Monitor-PC.enable {
      wayland.windowManager.hyprland.settings.monitor = [
        "HDMI-A-1,1920x1080@75,0x0,1"
        ",preferred,auto,1"
      ];
    })

    (lib.mkIf config.Monitor-Notebook.enable {
      wayland.windowManager.hyprland.settings.monitor = [
        "eDP-1,1366x768@60,0x0,1"
        ",preferred,auto,1"
      ];
    })

    (lib.mkIf config.Monitor-Netbook.enable {
      wayland.windowManager.hyprland.settings.monitor = [
        "eDP-1,1366x768@60,0x0,1"
        ",preferred,auto,1"
      ];
    })
  ];
}
