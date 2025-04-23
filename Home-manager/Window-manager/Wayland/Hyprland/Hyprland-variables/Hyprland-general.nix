_: {
  wayland.windowManager.hyprland = {
    settings = {
      general = {
        # Configuración general.
        border_size = 1;
        no_border_on_floating = false;
        gaps_in = 5;
        gaps_out = 20;
        gaps_workspaces = 0;
        "col.inactive_border" = "0xff444444";
        "col.active_border" = "0xffffffff";
        "col.nogroup_border" = "0xffffaaff";
        "col.nogroup_border_active" = "0xffff00ff";
        layout = "dwindle";
        no_focus_fallback = false;
        resize_on_border = false;
        extend_border_grab_area = 15;
        hover_icon_on_border = true;
        allow_tearing = false;
        resize_corner = 0;

        # Configuración snap.
        snap = {
          enabled = false;
          window_gap = 10;
          monitor_gap = 10;
          border_overlap = false;
        };
      };
    };
  };
}
