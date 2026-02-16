{
  pkgs,
  config,
  lib,
  ...
}:
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;

    settings = {
      general.locale = "es";

      monitor = [ "HDMI-A-1, 1920x1080@75, 0x0, 1" ];

      input = {
        kb_layout = "latam";
        sensitivity = 0;
        accel_profile = "flat";
        force_no_accel = true;
        touchpad.natural_scroll = true;
      };

      env = [
        "QT_QPA_PLATFORMTHEME,qt6ct"
      ];

      decoration = {
        blur = {
          enabled = false;
        };
        shadow = {
          enabled = false;
        };
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vfr = false;
      };

      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };

      "$mod" = "SUPER";
      "$terminal" = "kitty";

      bind = [
        "$mod, Return, exec, $terminal"
        "$mod SHIFT, Q, killactive"
        "$mod, M, exit"
        "$mod CTRL SHIFT, left, movewindow, l"
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        "$mod, 1, workspace, 1"
        "$mod, 2, workspace, 2"
        "$mod, 3, workspace, 3"
        "$mod, 4, workspace, 4"
        "$mod, 5, workspace, 5"
        "$mod, 6, workspace, 6"
        "$mod, 7, workspace, 7"
        "$mod, 8, workspace, 8"
        "$mod, 9, workspace, 9"
        "$mod, 0, workspace, 10"
        "$mod SHIFT, 1, movetoworkspace, 1"
        "$mod SHIFT, 2, movetoworkspace, 2"
        "$mod SHIFT, 3, movetoworkspace, 3"
        "$mod SHIFT, 4, movetoworkspace, 4"
        "$mod SHIFT, 5, movetoworkspace, 5"
        "$mod SHIFT, 6, movetoworkspace, 6"
        "$mod SHIFT, 7, movetoworkspace, 7"
        "$mod SHIFT, 8, movetoworkspace, 8"
        "$mod SHIFT, 9, movetoworkspace, 9"
        "$mod SHIFT, 0, movetoworkspace, 10"
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];

      bindd = [
        "$mod, D, Lanzador de aplicaciones, exec, noctalia-shell ipc call launcher toggle"
        "$mod, Escape, Menú de sesión, exec, noctalia-shell ipc call sessionMenu toggle"
        "$mod, L, Bloquear pantalla, exec, noctalia-shell ipc call lockScreen lock"
        "$mod, N, Centro de notificaciones, exec, noctalia-shell ipc call notificationHistory toggle"
        "$mod, C, Centro de control, exec, noctalia-shell ipc call controlCenter toggle"
        "$mod, W, Selector de wallpaper, exec, noctalia-shell ipc call wallpaperSelector toggle"
      ];

      bindel = [
        ", XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase"
        ", XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease"
        ", XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
        ", XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"
      ];

      bindl = [
        ", XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput"
        ", XF86AudioMicMute, exec, noctalia-shell ipc call volume muteInput"
        ", XF86AudioPlay, exec, noctalia-shell ipc call media playPause"
        ", XF86AudioNext, exec, noctalia-shell ipc call media next"
        ", XF86AudioPrev, exec, noctalia-shell ipc call media previous"
      ];
    };

    systemd = {
      enable = true;
      enableXdgAutostart = true;
      variables = [ "--all" ];
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Tela-black-dark";
      package = pkgs.tela-icon-theme;
    };
    font = {
      name = "Inter";
      size = 11;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 16;
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk4";
  };

  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    adw-gtk3
    tela-icon-theme
    bibata-cursors
  ];

  home.file = {
    "Imágenes/Wallpapers/Astronaut.png".source = ./Wallpapers/Astronaut.png;
    "Imágenes/Wallpapers/Black-Hole.png".source = ./Wallpapers/Black-Hole.png;
    "Imágenes/Wallpapers/Nebula.png".source = ./Wallpapers/Nebula.png;
    "Imágenes/Wallpapers/NixOS.png".source = ./Wallpapers/NixOS.png;
    "Imágenes/Wallpapers/NixOS-1.png".source = ./Wallpapers/NixOS-1.png;
  };

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
}
