{pkgs,...}:

{

  services = {
  	desktopManager = {
  		plasma6 = {
  			enable = true;
  			enableQt5Integration = false;
  			notoPackage = pkgs.noto-fonts;
  		};
  	};
  };

}
