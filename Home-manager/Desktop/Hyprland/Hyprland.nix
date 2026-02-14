{ pkgs, config, lib, ... }: 
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

  # ════════════════════════════════════════════════════════════════════
  # NOCTALIA SHELL
  # ════════════════════════════════════════════════════════════════════
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;
    
    settings = {
      bar = {
        barType = "compact";
        position = "top";
        floating = true;
        showCapsule = false;
        
        widgets = {
          left = [
            { id = "Launcher"; }
            { id = "Clock"; formatHorizontal = "HH:mm"; useMonospacedFont = true; usePrimaryColor = true; }
            { id = "SystemMonitor"; }
            { id = "ActiveWindow"; }
            { id = "MediaMini"; }
          ];
          center = [
            { id = "Workspace"; hideUnoccupied = false; labelMode = "none"; }
          ];
          right = [
            { id = "Tray"; }
            { id = "NotificationHistory"; }
            { id = "Battery"; warningThreshold = 30; alwaysShowPercentage = false; }
            { id = "Volume"; }
            { id = "Brightness"; }
            { id = "Network"; }
            { id = "Bluetooth"; }
            { id = "ControlCenter"; useDistroLogo = true; }
          ];
        };
      };

      appLauncher = {
        position = "center";
        viewMode = "list";
        sortByMostUsed = false;
        showCategories = false;
        clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
        clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
        terminalCommand = "kitty -e";
      };

      notifications = {
        enabled = true;
        location = "top_right";
        enableMediaToast = true;
        sounds = { enabled = false; volume = 0.5; separateSounds = false; excludedApps = "discord,firefox,chrome"; };
      };

      osd = {
        enabled = true;
        location = "top_right";
      };

      controlCenter = {
        position = "close_to_bar_button";
        diskPath = "/";
        shortcuts = {
          left = [ { id = "Network"; } { id = "Bluetooth"; } { id = "WallpaperSelector"; } { id = "NoctaliaPerformance"; } ];
          right = [ { id = "Notifications"; } { id = "PowerProfile"; } { id = "KeepAwake"; } { id = "NightLight"; } ];
        };
        cards = [
          { enabled = true; id = "profile-card"; }
          { enabled = true; id = "shortcuts-card"; }
          { enabled = true; id = "audio-card"; }
          { enabled = true; id = "brightness-card"; }
          { enabled = true; id = "weather-card"; }
          { enabled = true; id = "media-sysmon-card"; }
        ];
      };

      dock = {
        enabled = false;
      };

      sessionMenu = {
        position = "center";
        enableCountdown = true;
        powerOptions = [
          { action = "lock"; enabled = true; }
          { action = "suspend"; enabled = true; }
          { action = "hibernate"; enabled = true; }
          { action = "reboot"; enabled = true; }
          { action = "logout"; enabled = true; }
          { action = "shutdown"; enabled = true; }
        ];
      };

      systemMonitor = {
        externalMonitor = "btop";
      };

      audio = { volumeStep = 5; volumeOverdrive = false; volumeFeedback = false; cavaFrameRate = 30; visualizerType = "linear"; };
      brightness = { brightnessStep = 5; enforceMinimum = true; enableDdcSupport = false; };

      wallpaper = {
        enabled = true;
        directory = "${config.xdg.userDirs.pictures}/Wallpapers";
        panelPosition = "follow_bar";
      };

      general = {
        avatarImage = "${config.home.homeDirectory}/.face";
        language = "es";
      };

      location = {
        name = "Monteros,Tucuman,Argentina";
        firstDayOfWeek = -1;
      };

      network = {
        wifiEnabled = true;
      };

      colorSchemes = {
        useWallpaperColors = true;
       generationMethod = "faithful";
      };

      templates = {
        gtk = true;
        qt = true;
        kitty = true;
        firefox = true;
        zenbrowser = false;
        vscode = true;
        discord = true;
        cava = true;
        hyprland = true;
        enableUserTemplates = false;
      };
    };
  };

  # ════════════════════════════════════════════════════════════════════
  # GTK - Estilo similar a tu config de GNOME
  # ════════════════════════════════════════════════════════════════════
  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    iconTheme = {
      name = "Tela-black-dark";
      package = pkgs.tela-icon-theme;
    };
    cursorTheme = {
      name = "Bibata-Modern";
      package = pkgs.bibata-cursors;
      size = 20;
    };
    font = {
      name = "Inter";
      size = 11;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/privacy" = {
      remember-recent-files = false;
      remove-old-trash-files = true;
      old-files-age = 2;
      remove-old-temp-files = true;
      report-technical-problems = false;
    };
  };

  # ════════════════════════════════════════════════════════════════════
  # PAQUETES
  # ════════════════════════════════════════════════════════════════════
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
    matugen
    adw-gtk3
    tela-icon-theme
    bibata-cursors
    pywalfox-native
  ];

  # ════════════════════════════════════════════════════════════════════
  # PYWALFOX - Registrar native messenger al activar home-manager
  # ════════════════════════════════════════════════════════════════════
  home.activation.pywalfoxInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.pywalfox-native}/bin/pywalfox install 2>/dev/null || true
  '';
  
  home.file = {
  "Imágenes/Wallpapers/NixOS.png".source = ./Wallpapers/NixOS.png;
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
