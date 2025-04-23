{ ... }:

{

  programs.kitty = {
	enable = true;
	#themeFile = "gruvbox-dark-hard";

	settings = {
		confirm_os_window_close = 0;
		background_opacity = "0.66";
		scrollback_lines = 10000;
		enable_audio_bell = false;
	};
  };

}
