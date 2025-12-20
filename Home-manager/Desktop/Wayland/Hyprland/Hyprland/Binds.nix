# Home-manager/Window-Manager/Wayland/Hyprland/Hyprland/Variables/Binds/Binds.nix
_: {
  wayland.windowManager.hyprland = {
    settings = {
      "$mainMod" = "SUPER";

      bind = [
        # === APLICACIONES ===
        "$mainMod, Return, exec, kitty"
        "$mainMod, D, exec, rofi -show drun || pkill rofi"
        "$mainMod, E, exec, nemo"
        "$mainMod, B, exec, firefox"

        # === VENTANAS ===
        "$mainMod SHIFT, Q, killactive"
        "$mainMod, F, fullscreen, 0"
        "$mainMod SHIFT, F, fullscreen, 1"
        "$mainMod, Space, togglefloating"
        "$mainMod, P, pseudo" # Dwindle pseudo
        "$mainMod, T, togglesplit" # Dwindle split

        # === FOCUS ===
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, h, movefocus, l"
        "$mainMod, j, movefocus, d"
        "$mainMod, k, movefocus, u"
        "$mainMod, l, movefocus, r"

        # === WORKSPACES ===
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        # Workspace navigation
        "$mainMod, mouse_down, workspace, e-1"
        "$mainMod, mouse_up, workspace, e+1"
        "$mainMod ALT, left, workspace, e-1"
        "$mainMod ALT, right, workspace, e+1"

        # === MOVER VENTANAS ===
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
        "$mainMod CTRL, c, movetoworkspace, empty"

        # Mover físicamente ventana
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"
        "$mainMod SHIFT, h, movewindow, l"
        "$mainMod SHIFT, j, movewindow, d"
        "$mainMod SHIFT, k, movewindow, u"
        "$mainMod SHIFT, l, movewindow, r"

        # === RESIZE ===
        "$mainMod CTRL, left, resizeactive, -80 0"
        "$mainMod CTRL, right, resizeactive, 80 0"
        "$mainMod CTRL, up, resizeactive, 0 -80"
        "$mainMod CTRL, down, resizeactive, 0 80"
        "$mainMod CTRL, h, resizeactive, -80 0"
        "$mainMod CTRL, j, resizeactive, 0 80"
        "$mainMod CTRL, k, resizeactive, 0 -80"
        "$mainMod CTRL, l, resizeactive, 80 0"

        # === MOVER FLOTANTE ===
        "$mainMod ALT, left, moveactive, -80 0"
        "$mainMod ALT, right, moveactive, 80 0"
        "$mainMod ALT, up, moveactive, 0 -80"
        "$mainMod ALT, down, moveactive, 0 80"
        "$mainMod ALT, h, moveactive, -80 0"
        "$mainMod ALT, j, moveactive, 0 80"
        "$mainMod ALT, k, moveactive, 0 -80"
        "$mainMod ALT, l, moveactive, 80 0"

        # === SCREENSHOTS ===
        ", Print, exec, mkdir -p \"$HOME/Imágenes/Capturas de Pantalla\" && grimblast --notify copysave output - | convert - -strip png:- | tee \"$HOME/Imágenes/Capturas de Pantalla/Captura_full_$(date +'%Y-%m-%d_%H-%M-%S').png\" | wl-copy"
        "SHIFT, Print, exec, mkdir -p \"$HOME/Imágenes/Capturas de Pantalla\" && grimblast --notify copysave area - | convert - -strip png:- | tee \"$HOME/Imágenes/Capturas de Pantalla/Captura_area_$(date +'%Y-%m-%d_%H-%M-%S').png\" | wl-copy"

        # === AUDIO ===
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"

        # === BRILLO ===
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"

        # === SISTEMA ===
        "$mainMod, Escape, exec, hyprlock"
        "$mainMod SHIFT, Escape, exec, wlogout"
        "$mainMod SHIFT, R, exec, hyprctl reload"

        # === GRUPOS (útil para gaming) ===
        "$mainMod, G, togglegroup"
        "$mainMod, tab, changegroupactive, f"
        "$mainMod SHIFT, tab, changegroupactive, b"
      ];

      # === MOUSE BINDS ===
      bindm = [
        "ALT, mouse:272, movewindow"
        "ALT, mouse:273, resizewindow"
      ];

      # === BIND EXTRA ===
      bindc = [
        "ALT, mouse:272, togglefloating"
      ];

      # === BIND REPEAT (mantener presionado) ===
      binde = [
        "$mainMod CTRL SHIFT, left, resizeactive, -20 0"
        "$mainMod CTRL SHIFT, right, resizeactive, 20 0"
        "$mainMod CTRL SHIFT, up, resizeactive, 0 -20"
        "$mainMod CTRL SHIFT, down, resizeactive, 0 20"
      ];
    };
  };
}
