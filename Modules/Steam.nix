{
  config,
  pkgs,
  lib,
  ...
}:
let
  hytale-script = pkgs.writeShellScriptBin "hytale" ''
    HYTALE_CLIENT="$HOME/.local/share/Hytale/install/release/package/game/latest/Client/HytaleClient"

    if [[ ! -f "$HYTALE_CLIENT" ]]; then
      echo "Cliente no encontrado. Iniciando launcher para descarga..."
      ${pkgs.steam-run}/bin/steam-run ${pkgs.hytale-launcher}/bin/hytale-launcher
      exit 0
    fi

    echo "Iniciando launcher para autenticación..."
    ${pkgs.steam-run}/bin/steam-run ${pkgs.hytale-launcher}/bin/hytale-launcher &
    LAUNCHER_PID=$!

    echo "Esperando HytaleClient..."
    while ! ${pkgs.procps}/bin/pgrep -f HytaleClient > /dev/null 2>&1; do
      sleep 1
    done

    sleep 2

    CLIENT_PID=$(${pkgs.procps}/bin/pgrep -f HytaleClient)
    echo "HytaleClient encontrado: PID $CLIENT_PID"

    CMDLINE=$(cat /proc/$CLIENT_PID/cmdline | tr '\0' ' ')

    echo "Cerrando cliente original..."
    kill $CLIENT_PID 2>/dev/null
    kill $LAUNCHER_PID 2>/dev/null

    sleep 1

    echo "Relanzando con MangoHud y Gamemode..."
    exec ${pkgs.gamemode}/bin/gamemoderun ${pkgs.mangohud}/bin/mangohud ${pkgs.steam-run}/bin/steam-run $CMDLINE
  '';

  hytale-desktop = pkgs.makeDesktopItem {
    name = "hytale";
    desktopName = "Hytale";
    exec = "${hytale-script}/bin/hytale";
    icon = "hytale";
    categories = [ "Game" ];
    comment = "Hytale con MangoHud y Gamemode";
  };

  hytale = pkgs.symlinkJoin {
    name = "hytale";
    paths = [
      hytale-script
      hytale-desktop
    ];
  };
in
{
  options.Steam.enable = lib.mkEnableOption "Habilitar Steam con optimizaciones gaming";

  config = lib.mkIf config.Steam.enable {
    programs.steam = {
      enable = true;
      platformOptimizations.enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      extraPackages = with pkgs; [
        gamescope
      ];
    };
    
    programs.gamemode = {
      enable = true;
      enableRenice = true;

      settings = {
        general = {
          renice = 15;
          ioprio = 0;
          inhibit_screensaver = 1;
        };

        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 1;
          amd_performance_level = "high";
        };

        cpu = {
          park_cores = "no";
          pin_policy = "default";
        };
      };
    };

    services.udev.extraRules = ''
      # Permitir al grupo gamemode controlar performance de GPU AMD
      ACTION=="add", SUBSYSTEM=="drm", KERNEL=="card[0-9]*", DRIVERS=="amdgpu", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/drm/%k/device/power_dpm_force_performance_level", RUN+="${pkgs.coreutils}/bin/chgrp gamemode /sys/class/drm/%k/device/power_dpm_force_performance_level"
    '';

    environment.systemPackages = with pkgs; [
      (prismlauncher.override {
        controllerSupport = false;
        gamemodeSupport = true;
        textToSpeechSupport = false;
        jdks = [
          zulu25
        ];
      })
      hytale
    ];
  };
}
