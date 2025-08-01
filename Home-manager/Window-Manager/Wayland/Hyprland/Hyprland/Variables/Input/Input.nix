_: {
  wayland.windowManager.hyprland = {
    settings = {
      input = {
        # Configuración general.
        kb_model = "";
        kb_layout = "latam";
        kb_variant = "";
        kb_options = "";
        kb_rules = "";
        kb_file = "";
        numlock_by_default = false;
        resolve_binds_by_sym = false;
        repeat_rate = 25;
        repeat_delay = 600;
        sensitivity = 0;
        accel_profile = "adaptive";
        force_no_accel = false;
        left_handed = false;
        scroll_points = "";
        scroll_method = "2fg";
        scroll_button = 0;
        scroll_button_lock = 0;
        scroll_factor = 1.0;
        natural_scroll = false;
        follow_mouse = 1;
        focus_on_close = 0;
        mouse_refocus = true;
        float_switch_override_focus = 1;
        special_fallthrough = false;
        off_window_axis_events = 1;
        emulate_discrete_scroll = 1;

        # Configuración del Touchpad.
        touchpad = {
          disable_while_typing = true;
          natural_scroll = false;
          scroll_factor = 1.0;
          middle_button_emulation = false;
          tap_button_map = "";
          clickfinger_behavior = false;
          tap-to-click = true;
          drag_lock = false;
          tap-and-drag = true;
        };
      };
    };
  };
}
