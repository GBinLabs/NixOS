{ pkgs, config, ... }: 
let
  noctalia = cmd: [ "noctalia-shell" "ipc" "call" ] ++ (pkgs.lib.splitString " " cmd);
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    package = null;
    portalPackage = null;
    
    settings = {
      general.locale = "es";
      
      input = {
        kb_layout = "latam";
        touchpad.natural_scroll = true;
      };
      
      "$mod" = "SUPER";
      "$terminal" = "kitty";
      
      # Ejecutar Noctalia al inicio (si no usas systemd service)
      # exec-once = [ "noctalia-shell" ];
      
      bind = [
        # Aplicaciones
        "$mod, Return, exec, $terminal"
        "$mod SHIFT, Q, killactive"
        "$mod, M, exit"
        "$mod CTRL SHIFT, left, movewindow, l"
        
        # Ventanas
        "$mod, V, togglefloating"
        "$mod, F, fullscreen"
        "$mod, P, pseudo"
        "$mod, J, togglesplit"
        
        # Workspaces
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
        
        # Mover ventana a workspace
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
        
        # Scroll entre workspaces
        "$mod, mouse_down, workspace, e+1"
        "$mod, mouse_up, workspace, e-1"
      ];
      
      # Keybinds de Noctalia (usando spawn con lista)
      bindd = [
        "$mod, D, Lanzador de aplicaciones, exec, noctalia-shell ipc call launcher toggle"
        "$mod, Escape, Menú de sesión, exec, noctalia-shell ipc call sessionMenu toggle"
        "$mod, L, Bloquear pantalla, exec, noctalia-shell ipc call lockScreen lock"
        "$mod, N, Centro de notificaciones, exec, noctalia-shell ipc call notificationHistory toggle"
        "$mod, C, Centro de control, exec, noctalia-shell ipc call controlCenter toggle"
        "$mod, W, Selector de wallpaper, exec, noctalia-shell ipc call wallpaperSelector toggle"
      ];
      
      # Teclas multimedia
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

  # Configuración de Noctalia Shell
  programs.noctalia-shell = {
    enable = true;
    systemd.enable = true;  # Inicia automáticamente con la sesión
    
    settings = {
      # === BARRA PRINCIPAL ===
      bar = {
        barType = "simple";
        position = "top";  # top, bottom, left, right
        density = "default";  # default, compact
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
        displayMode = "always_visible";  # always_visible, auto_hide
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

      # === LANZADOR DE APLICACIONES ===
      appLauncher = {
        position = "center";
        viewMode = "list";  # list, grid
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

      # === NOTIFICACIONES ===
      notifications = {
        enabled = true;
        location = "top_right";  # top_right, top_left, bottom_right, bottom_left
        overlayLayer = true;
        backgroundOpacity = 1;
        respectExpireTimeout = false;
        lowUrgencyDuration = 3;
        normalUrgencyDuration = 8;
        criticalUrgencyDuration = 15;
        enableKeyboardLayoutToast = true;
        enableMediaToast = false;
        saveToHistory = {
          low = true;
          normal = true;
          critical = true;
        };
        sounds = {
          enabled = false;
          volume = 0.5;
          separateSounds = false;
          excludedApps = "discord,firefox,chrome";
        };
      };

      # === OSD (Volumen, Brillo, etc.) ===
      osd = {
        enabled = true;
        location = "top_right";
        autoHideMs = 2000;
        overlayLayer = true;
        backgroundOpacity = 1;
        enabledTypes = [ 0 1 2 ];  # Todos los tipos de OSD
      };

      # === CENTRO DE CONTROL ===
      controlCenter = {
        position = "close_to_bar_button";
        diskPath = "/";
        shortcuts = {
          left = [
            { id = "Network"; }
            { id = "Bluetooth"; }
            { id = "WallpaperSelector"; }
            { id = "NoctaliaPerformance"; }
          ];
          right = [
            { id = "Notifications"; }
            { id = "PowerProfile"; }
            { id = "KeepAwake"; }
            { id = "NightLight"; }
          ];
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

      # === DOCK ===
      dock = {
        enabled = true;
        position = "bottom";
        displayMode = "auto_hide";  # auto_hide, always_visible
        backgroundOpacity = 1;
        floatingRatio = 1;
        size = 1;
        onlySameOutput = true;
        colorizeIcons = false;
        pinnedStatic = false;
        inactiveIndicators = false;
        deadOpacity = 0.6;
        animationSpeed = 1;
        pinnedApps = [
          "firefox.desktop"
          "kitty.desktop"
          "org.gnome.Nautilus.desktop"
          "discord.desktop"
        ];
      };

      # === MENÚ DE SESIÓN ===
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

      # === MONITOR DE SISTEMA ===
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

      # === AUDIO ===
      audio = {
        volumeStep = 5;
        volumeOverdrive = false;
        volumeFeedback = false;
        cavaFrameRate = 30;
        visualizerType = "linear";
      };

      # === BRILLO ===
      brightness = {
        brightnessStep = 5;
        enforceMinimum = true;
        enableDdcSupport = false;
      };

      # === WALLPAPER ===
      wallpaper = {
        enabled = true;
        overviewEnabled = false;
        directory = "${config.home.homeDirectory}/Wallpapers";
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

      # === CONFIGURACIÓN GENERAL ===
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

      # === INTERFAZ ===
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

      # === UBICACIÓN Y CLIMA ===
      location = {
        name = "Buenos Aires";  # Cambia a tu ciudad
        weatherEnabled = true;
        weatherShowEffects = true;
        useFahrenheit = false;
        use12hourFormat = false;
        showWeekNumberInCalendar = false;
        showCalendarEvents = true;
        showCalendarWeather = true;
        analogClockInCalendar = false;
        firstDayOfWeek = 1;  # Lunes
      };

      # === RED ===
      network = {
        wifiEnabled = true;
        bluetoothRssiPollingEnabled = false;
        wifiDetailsViewMode = "grid";
        bluetoothDetailsViewMode = "grid";
        bluetoothHideUnnamedDevices = false;
      };

      # === LUZ NOCTURNA ===
      nightLight = {
        enabled = false;
        forced = false;
        autoSchedule = true;
        nightTemp = "4000";
        dayTemp = "6500";
        manualSunrise = "06:30";
        manualSunset = "18:30";
      };

      # === ESQUEMA DE COLORES ===
      colorSchemes = {
        predefinedScheme = "Noctalia (default)";  # Noctalia (default), Monochrome, etc.
        darkMode = true;
        useWallpaperColors = false;
        schedulingMode = "off";
      };
    };

    # Colores personalizados Material 3 (opcional, para tema oscuro minimalista)
    # colors = {
    #   mPrimary = "#aaaaaa";
    #   mSecondary = "#a7a7a7";
    #   mTertiary = "#cccccc";
    #   mError = "#dddddd";
    #   mSurface = "#111111";
    #   mSurfaceVariant = "#191919";
    #   mHover = "#1f1f1f";
    #   mOnPrimary = "#111111";
    #   mOnSecondary = "#111111";
    #   mOnTertiary = "#111111";
    #   mOnSurface = "#828282";
    #   mOnSurfaceVariant = "#5d5d5d";
    #   mOnError = "#111111";
    #   mOnHover = "#ffffff";
    #   mOutline = "#3c3c3c";
    #   mShadow = "#000000";
    # };
  };

  # Wallpapers declarativos (opcional)
 # home.file.".cache/noctalia/wallpapers.json".text = builtins.toJSON {
  #  defaultWallpaper = "${config.home.homeDirectory}/Wallpapers/default.png";
  #};

  # Paquetes necesarios para clipboard
  home.packages = with pkgs; [
    wl-clipboard
    cliphist
  ];
}
