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
        barType = "simple";
        position = "top";
        density = "default";
        floating = false;
        showCapsule = true;
        capsuleOpacity = 1;
        backgroundOpacity = 0.93;
        showOutline = false;
        marginVertical = 4;
        marginHorizontal = 4;
        frameThickness = 8;
        frameRadius = 12;
        outerCorners = true;
        displayMode = "always_visible";
        autoHideDelay = 500;
        autoShowDelay = 150;
        
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
        sortByMostUsed = true;
        showCategories = true;
        enableClipboardHistory = true;
        autoPasteClipboard = false;
        enableClipPreview = true;
        clipboardWrapText = true;
        clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
        clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
        enableSettingsSearch = true;
        enableWindowsSearch = true;
        terminalCommand = "kitty -e";
        iconMode = "tabler";
        showIconBackground = false;
        pinnedApps = [
          "firefox.desktop"
          "kitty.desktop"
          "org.gnome.Nautilus.desktop"
        ];
      };

      notifications = {
        enabled = true;
        location = "top_right";
        overlayLayer = true;
        backgroundOpacity = 1;
        respectExpireTimeout = false;
        lowUrgencyDuration = 3;
        normalUrgencyDuration = 8;
        criticalUrgencyDuration = 15;
        enableKeyboardLayoutToast = true;
        enableMediaToast = false;
        saveToHistory = { low = true; normal = true; critical = true; };
        sounds = { enabled = false; volume = 0.5; separateSounds = false; excludedApps = "discord,firefox,chrome"; };
      };

      osd = {
        enabled = true;
        location = "top_right";
        autoHideMs = 2000;
        overlayLayer = true;
        backgroundOpacity = 1;
        enabledTypes = [ 0 1 2 ];
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
        enabled = true;
        position = "bottom";
        displayMode = "auto_hide";
        backgroundOpacity = 1;
        floatingRatio = 1;
        size = 1;
        onlySameOutput = true;
        colorizeIcons = false;
        pinnedStatic = false;
        inactiveIndicators = false;
        deadOpacity = 0.6;
        animationSpeed = 1;
        pinnedApps = [ "firefox.desktop" "kitty.desktop" "org.gnome.Nautilus.desktop" "discord.desktop" ];
      };

      sessionMenu = {
        position = "center";
        enableCountdown = true;
        countdownDuration = 10000;
        showHeader = true;
        largeButtonsStyle = true;
        largeButtonsLayout = "single-row";
        showNumberLabels = true;
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
        cpuWarningThreshold = 80;
        cpuCriticalThreshold = 90;
        memWarningThreshold = 80;
        memCriticalThreshold = 90;
        gpuWarningThreshold = 80;
        gpuCriticalThreshold = 90;
        cpuPollingInterval = 1000;
        gpuPollingInterval = 3000;
        memPollingInterval = 1000;
        diskPollingInterval = 30000;
        networkPollingInterval = 1000;
        enableDgpuMonitoring = false;
      };

      audio = { volumeStep = 5; volumeOverdrive = false; volumeFeedback = false; cavaFrameRate = 30; visualizerType = "linear"; };
      brightness = { brightnessStep = 5; enforceMinimum = true; enableDdcSupport = false; };

      wallpaper = {
        enabled = true;
        overviewEnabled = false;
        directory = "${config.xdg.userDirs.pictures}/Wallpapers";
        showHiddenFiles = false;
        viewMode = "single";
        setWallpaperOnAllMonitors = true;
        fillMode = "crop";
        automationEnabled = false;
        wallpaperChangeMode = "random";
        randomIntervalSec = 300;
        transitionDuration = 1500;
        transitionType = "random";
        panelPosition = "follow_bar";
        sortOrder = "name";
      };

      general = {
        avatarImage = "${config.home.homeDirectory}/.face";
        dimmerOpacity = 0.2;
        showScreenCorners = false;
        scaleRatio = 1;
        radiusRatio = 1;
        animationSpeed = 1;
        animationDisabled = false;
        compactLockScreen = false;
        lockOnSuspend = true;
        showSessionButtonsOnLockScreen = true;
        enableShadows = true;
        shadowDirection = "bottom_right";
        language = "es";
        enableLockScreenCountdown = true;
        lockScreenCountdownDuration = 10000;
      };

      ui = {
        fontDefaultScale = 1;
        fontFixedScale = 1;
        tooltipsEnabled = true;
        panelBackgroundOpacity = 0.93;
        panelsAttachedToBar = true;
        settingsPanelMode = "attached";
        wifiDetailsViewMode = "grid";
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
        boxBorderEnabled = false;
      };

      location = {
        name = "Monteros,Tucuman,Argentina";
        weatherEnabled = true;
        weatherShowEffects = true;
        useFahrenheit = false;
        use12hourFormat = false;
        showWeekNumberInCalendar = false;
        showCalendarEvents = true;
        showCalendarWeather = true;
        analogClockInCalendar = false;
        firstDayOfWeek = 1;
      };

      network = {
        wifiEnabled = true;
        bluetoothRssiPollingEnabled = false;
        wifiDetailsViewMode = "grid";
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
      };

      nightLight = {
        enabled = false;
        forced = false;
        autoSchedule = true;
        nightTemp = "4000";
        dayTemp = "6500";
        manualSunrise = "06:30";
        manualSunset = "18:30";
      };

      # ══════════════════════════════════════════════════════════════
      # COLORES DESDE WALLPAPER
      # ══════════════════════════════════════════════════════════════
      colorSchemes = {
        useWallpaperColors = true;
        predefinedScheme = "Gruvbox";
        darkMode = true;
        schedulingMode = "off";
        generateTemplatesForPredefined = true;
      };

      # ══════════════════════════════════════════════════════════════
      # TEMPLATES
      # ══════════════════════════════════════════════════════════════
      templates = {
        gtk = true;
        qt = true;
        kcolorscheme = false;
        kitty = true;
        foot = false;
        alacritty = false;
        firefox = true;
        zenbrowser = false;
        vscode = true;
        neovim = false;
        emacs = false;
        zed = false;
        discord = true;
        spotify = false;
        cava = false;
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
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
      size = 20;
    };
    font = {
      name = "Inter";
      size = 11;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "adw-gtk3-dark";
      icon-theme = "Tela-black-dark";
      cursor-theme = "Bibata-Modern-Ice";
      cursor-size = 20;
      font-name = "Inter 11";
      document-font-name = "Inter 11";
      monospace-font-name = "JetBrains Mono 10";
      font-antialiasing = "rgba";
      font-hinting = "slight";
      enable-animations = false;
    };
    "org/gnome/desktop/privacy" = {
      remember-recent-files = false;
      remove-old-trash-files = true;
      old-files-age = 1;
      remove-old-temp-files = true;
      report-technical-problems = false;
    };
  };

  # ════════════════════════════════════════════════════════════════════
  # QT - Configuración minimalista usando home-manager
  # ════════════════════════════════════════════════════════════════════
  qt = {
    enable = true;
    platformTheme.name = "qtct";
    style.name = "kvantum";
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
    qt6Packages.qt6ct
    libsForQt5.qt5ct
    libsForQt5.qtstyleplugin-kvantum
    qt6Packages.qtstyleplugin-kvantum
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
  #"Wallpapers/Mountains.jpg".source = ./Wallpapers/Mountains.jpg;
  #"Wallpapers/Forest.png".source = ./Wallpapers/Forest.png;
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
