{ pkgs, ... }:

{

  wayland.windowManager = {
	hyprland = {
		plugins = [
			pkgs.hyprlandPlugins.csgo-vulkan-fix
		];
		settings = {
			plugin = {
				csgo-vulkan-fix = {
					res_w = 1440;
					res_h = 1080;
					class = "cs2";
					fix_mouse = true;
				};
			};
		};
	};
  }; 

}
