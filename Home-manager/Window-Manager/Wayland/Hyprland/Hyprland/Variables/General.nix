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

      gestures = {};

      # Optimización adicional
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vfr = true;
        vrr = 1;
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        disable_autoreload = true;
        focus_on_activate = true;
        enable_swallow = false;
        animate_manual_resizes = false;
        animate_mouse_windowdragging = false;
        
        # Nuevas optimizaciones
        background_color = "0x000000";
      };

      # === RENDER OPTIMIZADO PARA FIREFOX ===
      render = {
        #explicit_sync = 0; # ← CRÍTICO: Desactivar para Firefox/LibreWolf
        #explicit_sync_kms = 0; # ← CRÍTICO: Desactivar para Firefox/LibreWolf
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
