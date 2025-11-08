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
      extraCompatPackages = with pkgs; [proton-ge-bin];
      gamescopeSession.enable = true;

      package = pkgs.steam.override {
        extraEnv = {
          AMD_VULKAN_ICD = "RADV";
          RADV_PERFTEST = "nggc,sam,rt";
          MESA_GLTHREAD = "true";
          PROTON_ENABLE_NVAPI = "1";
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
  };
}
