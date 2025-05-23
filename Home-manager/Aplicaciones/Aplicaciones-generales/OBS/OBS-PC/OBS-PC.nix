{ config, lib, ... }:

{
  options = {
    OBS-PC.enable = lib.mkEnableOption "Habilitar OBS-PC";
  };
  config = lib.mkIf config.OBS-PC.enable {
  	xdg.configFile."obs-studio" = {
  		source = ./config/obs-studio;
  		recursive = true;
  	};
  };

}
