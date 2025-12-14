{
  config,
  pkgs,
  lib,
  ...
}: {
  options.Steam.enable = lib.mkEnableOption "Habilitar Steam con optimizaciones gaming";

  config = lib.mkIf config.Steam.enable {
    programs.steam = {
      enable = true;
      platformOptimizations.enable = true;
      extraPackages = [ pkgs.latencyflex-vulkan ];
      extraCompatPackages = with pkgs; [proton-ge-bin proton-cachyos];
      package = pkgs.steam.override {
        extraEnv = {
          AMD_VULKAN_ICD = "RADV";
          RADV_PERFTEST = "nggc,sam,rt,antilag2";
          MESA_GLTHREAD = "true";
          PROTON_ENABLE_NVAPI = "1";
          WINEFSYNC = "1";
          PROTON_ENABLE_NTSYNC = "1";
          VK_INSTANCE_LAYERS = "VK_LAYER_MESA_anti_lag";
        };
      };
    };
    programs.gamemode = {
      enable = true;
      enableRenice = true;

      settings = {
        general = {
          renice = -15;
          ioprio = 0;
          inhibit_screensaver = 1;
        };

        gpu = {
          apply_gpu_optimisations = "accept-responsibility";
          gpu_device = 0;
          amd_performance_level = "high";
        };

        cpu = {
          park_cores = "no";
          pin_policy = "default";
        };
      };
    };
    environment.systemPackages = with pkgs; [
      (prismlauncher.override {
        controllerSupport = false;
        gamemodeSupport = true;
        textToSpeechSupport = false;
        jdks = [
          zulu25
        ];
      })
    ];
  };
}
