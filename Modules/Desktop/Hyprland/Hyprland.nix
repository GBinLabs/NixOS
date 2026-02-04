{ pkgs, ... }: {

  programs = {
  	hyprland = {
  		enable = true;
  		package = pkgs.hyprland;
  		portalPackage = pkgs.xdg-desktop-portal-hyprland;
  		withUWSM = true;
  		xwayland = {
  			enable = false;
  		};
  	};
  	uwsm = {
  		enable = true;
  		package = pkgs.uwsm;
  		waylandCompositors = {
  			hyprland = {
  				prettyName = "Hyprland";
  				comment = "Hyprland compositor managed by UWSM";
  				binPath = "/run/current-system/sw/bin/Hyprland";
			};
		};
  	};
  	silentSDDM = {
  		enable = true;
  		theme = "default";
  	};
  };

}
