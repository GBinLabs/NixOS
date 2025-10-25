{ pkgs, config, lib, ... }:
let
  gtkThemeName       = "Gruvbox-Dark";
  gtkThemePackage    = pkgs.gruvbox-gtk-theme;
  iconThemeName    = "Tela-brown-dark";  # o "Tela-orange-dark"
  iconThemePackage = pkgs.tela-icon-theme;
  cursorThemeName    = "Bibata-Modern-Amber";      # Cursor cálido para Gruvbox
  cursorThemePackage = pkgs.bibata-cursors;
  cursorSize         = 24;
in
{
  home.packages = with pkgs; [
    qt6ct
    qt6Packages.qtstyleplugin-kvantum
    libsForQt5.qtstyleplugin-kvantum
    gruvbox-kvantum  # Tema Gruvbox para Kvantum
  ];

  fonts.fontconfig.enable = true;

  gtk = {
    enable = true;
    font = {
      name = "JetBrains Mono";
      size = 10;
    };
    theme = {
      name    = gtkThemeName;
      package = gtkThemePackage;
    };
    iconTheme = {
      name    = iconThemeName;
      package = iconThemePackage;
    };
    cursorTheme = {
      name    = cursorThemeName;
      package = cursorThemePackage;
      size    = cursorSize;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qt6ct";
  };

  # Variables de entorno necesarias
  home.sessionVariables = {
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_STYLE_OVERRIDE = "kvantum";
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

  # Cursor theme
  home.pointerCursor = {
    name    = cursorThemeName;
    package = cursorThemePackage;
    size    = cursorSize;
    gtk.enable = true;
    x11 = {
      enable = true;
      defaultCursor = cursorThemeName;
    };
  };
}
