{
  config,
  pkgs,
  ...
}: let
  customized_sddm_astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "black_hole";
  };
  gtkThemeName = "Gruvbox-Dark";
  gtkThemePackage = pkgs.gruvbox-gtk-theme;
  iconThemeName = "Tela-brown-dark"; # o "Tela-orange-dark"
  iconThemePackage = pkgs.tela-icon-theme;
  cursorThemeName = "Bibata-Modern-Ice"; # Cursor cálido para Gruvbox
  cursorThemePackage = pkgs.bibata-cursors;
  cursorSize = 24;
in {
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland = {
        enable = false;
      };
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      package = pkgs.hyprland;
    };
    uwsm = {
      enable = true;
      package = pkgs.uwsm;
      waylandCompositors = {
        hyprland = {
          prettyName = "Hyprland";
          binPath = "/run/current-system/sw/bin/Hyprland";
        };
      };
    };
  };
  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland = {
          enable = true;
        };
        theme = "sddm-astronaut-theme";
        settings = {
          Theme = {
            Current = "sddm-astronaut-theme";
          };
        };
        package = pkgs.kdePackages.sddm;
        extraPackages = with pkgs; [
          customized_sddm_astronaut
          kdePackages.qtmultimedia
        ];
      };
      defaultSession = "hyprland-uwsm";
    };
  };

  ## Fonts.
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };

  environment.systemPackages = with pkgs; [
    customized_sddm_astronaut
    qt6Packages.qt6ct
    qt6Packages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    gruvbox-kvantum
  ];

  wayland.windowManager.hyprland = {
    enable = true;
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
        accel_profile = "flat";
        force_no_accel = true;
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

      "$mainMod" = "SUPER";

      bind = [
        # === APLICACIONES ===
        "$mainMod, Return, exec, kitty"
        "$mainMod, D, exec, rofi -show drun || pkill rofi"
        "$mainMod, E, exec, nemo" # File manager
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
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
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

  xdg.userDirs = {
    enable = true;
    desktop = "$HOME/Escritorio";
    documents = "$HOME/Documentos";
    download = "$HOME/Descargas";
    music = "$HOME/Música";
    pictures = "$HOME/Imágenes";
    videos = "$HOME/Vídeos";
    templates = "$HOME/Plantillas";
    publicShare = "$HOME/Público";
  };

  fonts.fontconfig.enable = true;

  #gtk = {
  #enable = true;
  # font = {
  #   name = "JetBrains Mono";
  #   size = 10;
  # };
  # theme = {
  #   name = gtkThemeName;
  #   package = gtkThemePackage;
  # };
  # iconTheme = {
  #   name = iconThemeName;
  #   package = iconThemePackage;
  # };
  #cursorTheme = {
  #  name = cursorThemeName;
  #  package = cursorThemePackage;
  #  size = cursorSize;
  #};
  #};

  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
  };

  # Configuración de qt6ct
  xdg.configFile."qt6ct/qt6ct.conf".text = ''
    [Appearance]
    color_scheme_path=${config.xdg.configHome}/qt6ct/colors/gruvbox-dark.conf
    custom_palette=true
    icon_theme=${iconThemeName}
    standard_dialogs=default
    style=kvantum-dark

    [Fonts]
    fixed="JetBrains Mono,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"
    general="JetBrains Mono,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1"

    [Interface]
    activate_item_on_single_click=1
    buttonbox_layout=0
    cursor_flash_time=1000
    dialog_buttons_have_icons=1
    double_click_interval=400
    gui_effects=@Invalid()
    keyboard_scheme=2
    menus_have_icons=true
    show_shortcuts_in_context_menus=true
    stylesheets=@Invalid()
    toolbutton_style=4
    underline_shortcut=1
    wheel_scroll_lines=3

    [SettingsWindow]
    geometry=@ByteArray(\x1\xd9\xd0\xcb\0\x3\0\0\0\0\0\0\0\0\0\0\0\0\x2\xd7\0\0\x2\x37\0\0\0\0\0\0\0\0\0\0\x2\xd7\0\0\x2\x37\0\0\0\0\0\0\0\0\a\x80\0\0\0\0\0\0\0\0\0\0\x2\xd7\0\0\x2\x37)

    [Troubleshooting]
    force_raster_widgets=1
    ignored_applications=@Invalid()
  '';

  # Paleta de colores Gruvbox Dark para qt6ct
  xdg.configFile."qt6ct/colors/gruvbox-dark.conf".text = ''
    [ColorScheme]
    active_colors=#ebdbb2, #3c3836, #504945, #3c3836, #1d2021, #282828, #ebdbb2, #ebdbb2, #ebdbb2, #282828, #1d2021, #000000, #458588, #ebdbb2, #83a598, #d3869b, #282828, #000000, #3c3836, #ebdbb2, #80000000
    disabled_colors=#928374, #3c3836, #504945, #3c3836, #1d2021, #282828, #928374, #928374, #928374, #282828, #1d2021, #000000, #458588, #928374, #83a598, #d3869b, #282828, #000000, #3c3836, #ebdbb2, #80000000
    inactive_colors=#ebdbb2, #3c3836, #504945, #3c3836, #1d2021, #282828, #ebdbb2, #ebdbb2, #ebdbb2, #282828, #1d2021, #000000, #458588, #ebdbb2, #83a598, #d3869b, #282828, #000000, #3c3836, #ebdbb2, #80000000
  '';

  # Configuración de Kvantum para usar el tema de gruvbox-kvantum
  xdg.configFile."Kvantum/kvantum.kvconfig".text = ''
    [General]
    theme=Gruvbox-Dark-Blue
  '';
}
