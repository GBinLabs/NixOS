_: {
  programs.cava = {
    enable = true;
  };

  xdg.configFile."cava/config".text = ''
    # Custom cava config

    [general]
    autosens = 1
    overshoot = 0

    [color]
    gradient = 1
    gradient_count = 8

    gradient_color_1 = '#99991a'
    gradient_color_2 = '#a28e00'
    gradient_color_3 = '#ab8200'
    gradient_color_4 = '#b37400'
    gradient_color_5 = '#bb6600'
    gradient_color_6 = '#c25400'
    gradient_color_7 = '#c8400d'
    gradient_color_8 = '#cd231d'

  '';

  xdg.configFile."cava/config1".text = ''

    [general]
    bars = 12
    sleep_timer = 10

    [input]
    method = pulse

    [output]
    method = raw
    data_format = ascii
    ascii_max_range = 6

  '';
}
