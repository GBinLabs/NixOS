{ config, lib, ... }:

{
  options = {
    OBS-Notebook.enable = lib.mkEnableOption "Habilitar OBS-Notebook";
  };
  config = lib.mkIf config.OBS-Notebook.enable {
  	xdg.configFile."obs-studio" = {
  		source = ./.config/obs-studio;
  		recursive = true;
  	};
  };

}
