_: {
  home.sessionVariables = {
    # -------------------------------------------------------------------------
    # Esenciales Wayland & Hyprland
    # -------------------------------------------------------------------------
    XDG_SESSION_TYPE = "wayland";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_DESKTOP = "Hyprland";
    NIXOS_OZONE_WL = "1"; # Forzar Wayland para apps Electron/Chromium vía Ozone
    HYPRLAND_DEBUG = "0"; # Deshabilitar logs de debug de Hyprland
    # Evita que wlroots intente usar renderizado por software si falla la aceleración por hardware
    WLR_RENDERER_ALLOW_SOFTWARE = "0";

    AMD_VULKAN_ICD = "RADV";

    vblank_mode = "0"; # Deshabilitar VSync a nivel driver Mesa (app/compositor gestionan)
    MESA_GLTHREAD = "true"; # Habilitar multi-hilo para OpenGL (beneficia CPU-bound & DXVK)
    MESA_NO_ERROR = "1"; # Deshabilitar chequeo de errores GL/VK (ligero boost, oculta errores)

    RADV_PERFTEST = "aco,gpl,nggc";
    RADV_DEBUG = ""; # Asegurar que el debug esté deshabilitado

    # Optimización potencial para juegos UE4/UE5 (mejora orden renderizado de capas Multiple Render Target)
    RADV_ENABLE_MRT_LAYER_ORDERING = "true";
    
    DXVK_ASYNC = "1"; # Compilación asíncrona de shaders (reduce stutter)
    DXVK_LOG_LEVEL = "none"; # Deshabilitar logs de DXVK para mínimo overhead

    VKD3D_DEBUG = "none"; # Deshabilitar logs de VKD3D para mínimo overhead

    PROTON_USE_WAYLAND = "1"; # Intentar usar backend Wayland nativo (puede requerir "0" para juegos problemáticos)
    PROTON_FORCE_LARGE_ADDRESS_AWARE = "1"; # Permitir a juegos 32-bit usar más de 2GB de RAM
    PROTON_ENABLE_NVAPI = "1"; # Habilitar stubs NVAPI (necesario para algunos juegos/features como DLSS incluso en AMD)
    PROTON_ENABLE_NGX_UPDATER = "0"; # Deshabilitar updater de DLSS (no aplica a AMD)
    PROTON_LOG = "0"; # Deshabilitar logs de Proton (poner "1" para diagnosticar)

    STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "1";

    # Usa una versión más "pesada" del runtime, incluyendo más bibliotecas como GTK2, etc.
    STEAM_RUNTIME_HEAVY = "1";

    GAMEMODE_AUTO_LAUNCH = "1"; # Habilitar Feral GameMode automáticamente (si está instalado)
    ENABLE_VKBASALT = "0"; # Deshabilitar vkBasalt (post-procesado) globalmente

    SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS = "0";

    GDK_BACKEND = "wayland,x11"; # GTK
    QT_QPA_PLATFORM = "wayland;xcb"; # Qt5/Qt6
    QT_AUTO_SCREEN_SCALE_FACTOR = "1"; # Evitar auto-escalado Qt
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # Mejor integración Qt en Tiling WMs
    SDL_VIDEODRIVER = "wayland,x11"; # SDL2

    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # 'auto' suele preferir wayland si está disponible
    MOZ_ENABLE_WAYLAND = "1"; # Firefox

    SDL_AUDIODRIVER = "pipewire"; # Preferir PipeWire para SDL

    _JAVA_AWT_WM_NONREPARENTING = "1"; # Arreglo común para GUIs Java en Tiling WMs
    JAVA_TOOL_OPTIONS = "-Dsun.java2d.opengl=true"; # Aceleración H/W para Java2D
    
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };
}

