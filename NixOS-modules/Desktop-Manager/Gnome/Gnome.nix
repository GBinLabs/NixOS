{ pkgs, ... }:

{

  services = {
  	desktopManager = {
			gnome = {
				enable = true;
			};
		};
  	xserver = {
		enable = true;
		excludePackages = with pkgs; [
			xterm
		];
	};
	gnome = {
		core-apps = {
			enable = false;	
		};
		localsearch = {
			enable = true;
		};
		tinysparql = {
			enable = true;
		};
		games = {
			enable = false;
		};
		core-developer-tools = {
			enable = false;
		};
	};
  };
  
  environment = {
  	gnome = {
  		excludePackages = with pkgs; [
  			gnome-tour
  		];
  	};
  };
  

}
