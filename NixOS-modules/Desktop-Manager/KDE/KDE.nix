{pkgs, ...}:

{

  services = {
	desktopManager = {
		plasma6 = {
			enable = true;
			enableQt5Integration = false;
			notoPackage = pkgs.noto-fonts;
		};
	};
	xserver = {
		enable = true;
		layout = "latam";  # Español Latinoamericano
		xkbVariant = "";   # Variante vacía (usa la predeterminada)
	};
  };

}
