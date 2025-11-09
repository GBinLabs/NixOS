_: {
  home.sessionVariables = {
    # === TEMAS (GTK + Qt) ===
    GTK_THEME = "Gruvbox"; # GTK2/3/4
    QT_QPA_PLATFORMTHEME = "qt6ct"; # Panel de control Qt
    QT_STYLE_OVERRIDE = "kvantum"; # Motor de estilo
    QT_QPA_PLATFORM = "wayland"; # Prioridad Wayland

    # === Variables que ya tenías ===
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_ENABLE_HIGHDPI_SCALING = "1";

    # === Otras apps que respetan temas ===
    XCURSOR_THEME = "Gruvbox-dark"; # Cursor
    XCURSOR_SIZE = "24";
  };
}
