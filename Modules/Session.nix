# configuration.nix
{
  # ============================================
  # VARIABLES DE ENTORNO GLOBALES (WAYLAND)
  # ============================================
  environment.sessionVariables = {
    # === Aplicaciones Electron (Discord, Upscayl, etc.) ===
    NIXOS_OZONE_WL = "1";

    # === Navegadores ===
    MOZ_ENABLE_WAYLAND = "1"; # Firefox/Thunderbird nativo Wayland
    MOZ_WAYLAND_USE_VAAPI = "1"; # Hardware acceleration
    MOZ_DISABLE_RDD_SANDBOX = "1"; # Fix para VAAPI en algunos GPUs

    # === Multimedia y Gaming ===
    SDL_VIDEODRIVER = "wayland"; # SDL2 -> Wayland
    SDL_AUDIODRIVER = "pipewire"; # SDL2 -> PipeWire
    GLFW_PLATFORM = "wayland"; # GLFW -> Wayland
    CLUTTER_BACKEND = "wayland"; # Clutter/GTK3+ apps

    # === GTK ===
    GTK_THEME = "Gruvbox";
    GDK_BACKEND = "wayland";

    # === Qt ===
    QT_QPA_PLATFORM = "wayland"; # Wayland primero, fallback X11
    QT_QPA_PLATFORMTHEME = "qt6ct"; # Para configurar tema
    QT_STYLE_OVERRIDE = "kvantum";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_ENABLE_HIGHDPI_SCALING = "1"; # Reemplaza obsoleta QT_AUTO_SCREEN_SCALE_FACTOR

    # === Wine/Proton ===
    WINEESYNC = "1"; # Eventfd sync
    WINEFSYNC = "1"; # Futex sync
    WINE_CPU_TOPOLOGY = "16:4"; # Tu CPU (ajusta)
    PROTON_ENABLE_NVAPI = "1"; # DLSS/RTX
    PROTON_HIDE_NVIDIA_GPU = "0"; # Mostrar GPU real
  };

  # === LOCALE (no va en sessionVariables) ===
  i18n.defaultLocale = "es_AR.UTF-8";
}
