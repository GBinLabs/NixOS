{ pkgs, ... }: {

wayland = {
	windowManager = {
		hyprland = {
			enable = true;
			package = null;
			#extraConfig = "";
			#importantPrefixes = [];
			#plugins = [];
			portalPackage = null;
			settings = {
				general = {
					allow_tearing = true;
					locale = "es";
				};
				input = {
					kb_layout = "latam";
				};
			};
			#submaps = {};
			systemd = {
				enable = false;
			};
		};
	};
};
}
