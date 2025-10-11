{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    Steam.enable = lib.mkEnableOption "Habilitar Steam";
  };

  config = lib.mkIf config.Steam.enable {
    programs = {
      steam = {
        enable = true;
        extraCompatPackages = [pkgs.proton-ge-bin];
      };
      gamemode = {
        enable = true;
        settings = {
          general = {
            softrealtime = "auto";
            renice = -10;
            ioprio = 0;
          };
          gpu = {
	    apply_gpu_optimisations = "accept-responsibility";
      	    gpu_device = 0;
            amd_performance_level = "high";
  	  };
  	  cpu = {
      	    park_cores = "no";
            pin_cores = "yes";
          };
        };
        enableRenice = true;
      };
    };
  };
}
