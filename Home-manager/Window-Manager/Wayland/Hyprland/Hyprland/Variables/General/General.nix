# Home-manager/Window-Manager/Wayland/Hyprland/Variables/General.nix
{
  wayland.windowManager.hyprland = {
    settings = {
      general = {
        border_size = 2;
        gaps_in = 3;      # Reducido para más espacio
        gaps_out = 8;     # Reducido
        "col.active_border" = "0xffb4befe";  # Catppuccin Lavender
        "col.inactive_border" = "0xff313244";
        layout = "dwindle";
        allow_tearing = true;  # VRR/tearing para gaming
      };
      
      decoration = {
        rounding = 8;
        
        blur = {
          enabled = false;  # OFF para gaming
        };
        
        shadow = {
          enabled = true;
          range = 8;
          render_power = 2;
          color = "0xee1a1a1a";
        };
        
        dim_inactive = false;
      };
      
      animations = {
        enabled = true;
        bezier = [
          "easeOutQuint,0.22, 1, 0.36, 1"
          "linear,0, 0, 1, 1"
        ];
        
        animation = [
          "windows,1,3,easeOutQuint,slide"
          "border,1,4,linear"
          "fade,1,3,easeOutQuint"
          "workspaces,1,3,easeOutQuint,slide"
        ];
      };
      
      input = {
        kb_layout = "latam";
        follow_mouse = 1;
        sensitivity = 0;
        accel_profile = "flat";
        force_no_accel = true;  # CRITICAL para gaming
      };
      
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vfr = true;  # Variable Frame Rate
        vrr = 1;     # Variable Refresh Rate (Freesync)
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
      };
      
      # Performance
      render = {
        direct_scanout = true;  # Mejor para gaming fullscreen
      };
      
      xwayland = {
        force_zero_scaling = true;
      };
    };
  };
}
