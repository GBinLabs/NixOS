{ config, pkgs, ... }:

{

  home.file.".config/hypr/Wallpapers" = {
	source = ./Wallpapers;
	recursive = true;
  };

  services.hyprpaper = {
	enable = true;
	package = pkgs.hyprpaper;
	settings = {
		ipc = "on";
		splash = false;
		splash_offset = 2.0;

		preload = [
			"${config.home.homeDirectory}/.config/hypr/Wallpapers/Astronaut.png"
		];

		wallpaper = [
			",${config.home.homeDirectory}/.config/hypr/Wallpapers/Astronaut.png"
		];
	};
  };

  home.packages = with pkgs; [
	hyprpaper
  ];

}
