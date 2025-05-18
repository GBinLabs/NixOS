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
        gamescopeSession.enable = true;
        extraCompatPackages = [pkgs.proton-ge-bin];
      };
      gamescope = {
      	enable = true;
      	capSysNice = true;
      };
    };
    services.ananicy = {
    	enable = true;
    	package = pkgs.ananicy-cpp;
    	rulesProvider = pkgs.ananicy-cpp;
    	extraRules = [
    		{
    			"name" = "gamescope";
    			"nice" = -20;
    		}
    	];
    };
  };
}
