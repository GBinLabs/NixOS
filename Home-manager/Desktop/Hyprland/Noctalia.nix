{
  config,
  lib,
  pkgs,
  ...
}:
{

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
            {
              id = "Clock";
              formatHorizontal = "HH:mm";
              useMonospacedFont = true;
              usePrimaryColor = true;
            }
            { id = "SystemMonitor"; }
            { id = "ActiveWindow"; }
            { id = "MediaMini"; }
          ];
          center = [
            {
              id = "Workspace";
              hideUnoccupied = false;
              labelMode = "none";
            }
          ];
          right = [
            { id = "Tray"; }
            { id = "NotificationHistory"; }
            {
              id = "Battery";
              warningThreshold = 30;
              alwaysShowPercentage = false;
            }
            { id = "Volume"; }
            { id = "Brightness"; }
            { id = "Network"; }
            { id = "Bluetooth"; }
            {
              id = "ControlCenter";
              useDistroLogo = true;
            }
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
        sounds = {
          enabled = false;
          volume = 0.5;
          separateSounds = false;
          excludedApps = "discord,firefox,chrome";
        };
      };

      osd = {
        enabled = true;
        location = "top_right";
      };

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
          {
            enabled = true;
            id = "profile-card";
          }
          {
            enabled = true;
            id = "shortcuts-card";
          }
          {
            enabled = true;
            id = "audio-card";
          }
          {
            enabled = true;
            id = "brightness-card";
          }
          {
            enabled = true;
            id = "weather-card";
          }
          {
            enabled = true;
            id = "media-sysmon-card";
          }
        ];
      };

      dock = {
        enabled = false;
      };

      sessionMenu = {
        position = "center";
        enableCountdown = true;
        powerOptions = [
          {
            action = "lock";
            enabled = true;
          }
          {
            action = "suspend";
            enabled = true;
          }
          {
            action = "hibernate";
            enabled = true;
          }
          {
            action = "reboot";
            enabled = true;
          }
          {
            action = "logout";
            enabled = true;
          }
          {
            action = "shutdown";
            enabled = true;
          }
        ];
      };

      systemMonitor = {
        externalMonitor = "btop";
      };

      audio = {
        volumeStep = 5;
        volumeOverdrive = false;
        volumeFeedback = false;
        cavaFrameRate = 30;
        visualizerType = "linear";
      };
      brightness = {
        brightnessStep = 5;
        enforceMinimum = true;
        enableDdcSupport = false;
      };

      wallpaper = {
        enabled = true;
        directory = "${config.home.homeDirectory}/Imágenes/Wallpapers";
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
        generationMethod = "tonal-spot";
      };

      templates = {
        gtk = true;
        qt = true;
        kitty = true;
        pywalfox = true;
        zed = true;
        btop = true;
        discord = true;
        cava = true;
        hyprland = true;
      };
    };
  };

  home.packages = with pkgs; [
    matugen
    pywalfox-native
  ];

  home.activation.pywalfoxInstall = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.pywalfox-native}/bin/pywalfox install 2>/dev/null || true
  '';

  systemd.user.timers.noctalia-colors-init = {
    Unit.Description = "Timer para inicializar colores de Noctalia";
    Timer = {
      OnStartupSec = "10s";
      Unit = "noctalia-colors-init.service";
    };
    Install.WantedBy = [ "timers.target" ];
  };

  systemd.user.services.noctalia-colors-init = {
    Unit.Description = "Inicializar colores de Noctalia";
    Service = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "noctalia-init-colors" ''
        NOCTALIA="/etc/profiles/per-user/german/bin/noctalia-shell"
        WALLPAPER="${config.home.homeDirectory}/Imágenes/Wallpapers/Astronaut.png"
        WALLPAPER_TMP="${config.home.homeDirectory}/Imágenes/Wallpapers/NixOS.png"

        for i in $(seq 1 30); do
          if "$NOCTALIA" ipc call state all &>/dev/null; then
            break
          fi
          sleep 1
        done

        "$NOCTALIA" ipc call wallpaper set "$WALLPAPER_TMP" ""
        sleep 2
        "$NOCTALIA" ipc call wallpaper set "$WALLPAPER" ""
      '';
    };
  };

  # ── Pywalfox daemon (colores dinámicos en Firefox) ────────────────────
  systemd.user.services.pywalfox-daemon = {
    Unit = {
      Description = "Pywalfox Daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.pywalfox-native}/bin/pywalfox start";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
