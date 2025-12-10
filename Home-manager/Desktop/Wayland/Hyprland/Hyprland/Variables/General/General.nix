# Home-manager/Window-Manager/Wayland/Hyprland/Hyprland/Variables/General/General.nix
{
  wayland.windowManager.hyprland = {
    settings = {
      general = {
        border_size = 2;
        gaps_in = 3;
        gaps_out = 8;
        "col.active_border" = "0xffb4befe";
        "col.inactive_border" = "0xff313244";
        layout = "dwindle";
        allow_tearing = true;
        resize_on_border = true;
        extend_border_grab_area = 15;
      };

      decoration = {
        rounding = 8;
        blur.enabled = false;
        shadow.enabled = false;
        dim_inactive = false;
        screen_shader = "";
      };

      animations.enabled = false;

      input = {
        kb_layout = "latam";
        follow_mouse = 1;
        sensitivity = 0;
        accel_profile = "flat";
        force_no_accel = true;

        touchpad = {
          natural_scroll = false;
          disable_while_typing = true;
          tap-to-click = true;
          scroll_factor = 1.0;
        };
      };

      gestures = {};

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vfr = true;
        vrr = 1; # Cambiado de 2 a 1 (menos agresivo)
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        disable_autoreload = true;
        focus_on_activate = true;
        enable_swallow = false;
        swallow_regex = "";
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
      };

      render = {
        direct_scanout = true;
      };

      opengl = {
        nvidia_anti_flicker = false;
      };

      # === CURSOR (FIX DEL ROMBO) ===
      cursor = {
        no_hardware_cursors = true; # ← FIX: Deshabilitar cursores hardware
        no_break_fs_vrr = false; # Cambiado
        min_refresh_rate = 60; # Reducido para estabilidad
        hide_on_key_press = false;
        inactive_timeout = 0;
      };

      binds = {
        allow_workspace_cycles = false;
        workspace_back_and_forth = false;
        focus_preferred_method = 0;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        smart_split = false;
        smart_resizing = true;
      };

      master = {
        new_status = "master";
        mfact = 0.5;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      debug = {
        disable_logs = true;
        disable_time = true;
      };
    };
  };
}
