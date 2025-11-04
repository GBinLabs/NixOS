# Home-manager/Window-Manager/Wayland/Hyprland/Hyprland/Variables/General/General.nix
# CONFIGURACIÓN COMPARTIDA PC + NETBOOK
# Optimizada para máximo rendimiento (gaming focus)

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
        allow_tearing = true;  # VRR para gaming
      };
      
      decoration = {
        rounding = 8;
        
        # SIN BLUR (mejor performance)
        blur = {
          enabled = false;
        };
        
        # SIN SOMBRAS (mejor performance)
        shadow = {
          enabled = false;
        };
        
        # Sin dim
        dim_inactive = false;
      };
      
      # SIN ANIMACIONES (máximo FPS, mínima latencia)
      animations = {
        enabled = false;
      };
      
      # Si quieres animaciones MUY rápidas (descomentar si prefieres):
      # animations = {
      #   enabled = true;
      #   bezier = [ "linear,0,0,1,1" ];
      #   animation = [
      #     "windows,1,1,linear"
      #     "fade,0"
      #     "workspaces,1,1,linear"
      #   ];
      # };
      
      input = {
        kb_layout = "latam";
        follow_mouse = 1;
        sensitivity = 0;
        accel_profile = "flat";
        force_no_accel = true;  # CRÍTICO para gaming
      };
      
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        vfr = true;   # Variable Frame Rate
        vrr = 2;      # VRR siempre activo (0=off, 1=fullscreen, 2=always)
        mouse_move_enables_dpms = true;
        key_press_enables_dpms = true;
        
        # CRÍTICO para gaming
        no_direct_scanout = false;  # Permitir direct scanout
        
        # Reduce overhead
        disable_autoreload = true;
        focus_on_activate = true;
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
