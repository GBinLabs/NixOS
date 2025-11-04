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

        # Activar screen shader solo si tienes uno
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

      gestures = {
        #workspace_swipe = false;
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vfr = true;
        vrr = 2;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        disable_autoreload = true;
        focus_on_activate = true;

        # GAMING CRÍTICO
        #no_direct_scanout = false;
        enable_swallow = false;
        swallow_regex = "";

        # Reducir overhead
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;

        # Rendimiento
        #render_ahead_of_time = false;
        #render_ahead_safezone = 1;
      };

      # === OPTIMIZACIONES DE RENDERING ===
      render = {
        #explicit_sync = 2; # Wayland explicit sync (reduce latencia)
        #explicit_sync_kms = 2;
        direct_scanout = true;
      };

      # === OPTIMIZACIONES OPENGL ===
      opengl = {
        nvidia_anti_flicker = false;
        #force_introspection = 0;
      };

      # === CURSOR ===
      cursor = {
        no_hardware_cursors = false;
        no_break_fs_vrr = true;
        min_refresh_rate = 75; # Ajusta a tu monitor
        hide_on_key_press = false;
        inactive_timeout = 0;
      };

      # === BINDS ===
      binds = {
        allow_workspace_cycles = false;
        workspace_back_and_forth = false;
        focus_preferred_method = 0; # Historial
      };

      # === DWINDLE LAYOUT ===
      dwindle = {
        pseudotile = true;
        preserve_split = true;
        #no_gaps_when_only = false;
        smart_split = false;
        smart_resizing = true;
      };

      # === MASTER LAYOUT (por si lo usas) ===
      master = {
        new_status = "master";
        mfact = 0.5;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      # === DEBUG (solo si tienes problemas) ===
      debug = {
        disable_logs = true;
        disable_time = true;
      };
    };
  };
}
