{
  config,
  pkgs,
  lib,
  ...
}:
{
  options.Steam.enable = lib.mkEnableOption "Habilitar Steam con optimizaciones gaming";

  config = lib.mkIf config.Steam.enable {
    programs.steam = {
      enable = true;
      platformOptimizations.enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
    };

    programs.gamemode = {
      enable = true;
      enableRenice = true;

      settings = {
        general = {
          renice = 20;
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
          temurin-bin-25
        ];
      })
      #hytale-launcher
    ];
  };
}
