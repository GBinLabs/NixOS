_: {
  programs.kitty = {
    enable = true;
    themeFile = "GruvboxMaterialDarkHard";

    settings = {
      confirm_os_window_close = 0;
      background_opacity = "0.66";
      scrollback_lines = 10000;
      enable_audio_bell = false;

      # Fuente
      font_family = "JetBrains Mono";
      font_size = "11.0";

      # Blur
      background_blur = 20;

      # Performance
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;

      # Cursor
      cursor_shape = "block";
      cursor_blink_interval = 0;

      # Mouse
      mouse_hide_wait = 3;

      # Window
      remember_window_size = false;
      initial_window_width = 100;
      initial_window_height = 30;

      # Tabs
      tab_bar_edge = "bottom";
      tab_bar_style = "powerline";

      # Shell
      shell = ".";
    };
  };
}
