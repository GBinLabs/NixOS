_: {
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      general = {
        # locale = "es_AR";
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        middle_click_paste = false;
      };

      render = {
        direct_scanout = 1;
      };

      xwayland = {
        enabled = false;
      };

      input = {
        kb_layout = "latam";
        numlock_by_default = false;
        sensitivity = 0;
        accel_profile = "flat";
        force_no_accel = true;

        touchpad = {
          disable_while_typing = true;
          middle_button_emulation = false;
          tap-to-click = true;
        };
      };

      ecosystem = {
        no_update_news = true;
        no_donation_nag = true;
      };
    };
  };
}
