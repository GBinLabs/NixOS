# Home-manager/Window-Manager/Wayland/Hyprland/Hyprland/Variables/Entorno/Entorno.nix
{ ... }: {
  home.sessionVariables = {
    # === WAYLAND ===
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    
    # === QT/GTK ===
    GTK_THEME = "Gruvbox";
    QT_QPA_PLATFORMTHEME = "qt6ct";
    QT_STYLE_OVERRIDE = "kvantum";
    QT_QPA_PLATFORM = "wayland";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    
    GDK_BACKEND = "wayland";
    GDK_SCALE = "1";
    
    # === WAYLAND COMPOSITOR ===
    WLR_DRM_NO_ATOMIC = "1"; # ← Cambiado a 1 para Firefox
    WLR_NO_HARDWARE_CURSORS = "1"; # ← CRÍTICO: Deshabilitar cursores hardware
    WLR_USE_LIBINPUT = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "0";
    
    # === APLICACIONES ===
    NIXOS_OZONE_WL = "1";
    
    # === FIREFOX/LIBREWOLF ESPECÍFICO ===
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WAYLAND_USE_VAAPI = "1";
    MOZ_USE_XINPUT2 = "1";
    MOZ_DBUS_REMOTE = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1"; # Desactiva sandbox RDD que causa problemas
    
    SDL_VIDEODRIVER = "wayland";
    SDL_AUDIODRIVER = "pipewire";
    GLFW_PLATFORM = "wayland";
    
    # === IDIOMA ===
    LANG = "es_AR.UTF-8";
    LC_ALL = "es_AR.UTF-8";
    LC_MESSAGES = "es_AR.UTF-8";
  };
}
