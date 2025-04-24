# home.nix
{
  pkgs,
  lib,
  ...
}: let
  # Core configuration parameters
  enableHyprlandDebug = false; # Set to true for debugging output
  isAmdGpu = true;          # Set to false for NVIDIA or Intel GPUs
  enableHiDPI = false;       # Set to true for high-resolution displays

  # Resource paths
  vulkanPackage = pkgs.vulkan-loader;
  vulkanIcdPath = "${vulkanPackage}/share/vulkan/icd.d/radeon_icd.x86_64.json";

  # Helper function to set conditional values with defaults
  condVal = condition: valueIfTrue: valueIfFalse:
    if condition
    then valueIfTrue
    else valueIfFalse;
in {
  # --- PAQUETES RECOMENDADOS ---
  # Asegúrate de incluir gamemode y las herramientas necesarias para AMD
  home.packages =
    [
     pkgs.mesa
      pkgs.libva-utils
      pkgs.vulkan-tools
      #pkgs.amdvlk # Si quieres tener AMDLVK como opción, aunque RADV suele ser mejor
      pkgs.vkbasalt # Necesario si quieres usarlo con la opción de lanzamiento
      #pkgs.mangohud # Necesario para usar mangohud en opciones de lanzamiento
      #pkgs.gamescope # Necesario si quieres usarlo
      #pkgs.protontricks
      #pkgs.winetricks
    ];

  # --- VARIABLES DE ENTORNO OPTIMIZADAS ---
  home.sessionVariables = {
    # --- Configuración Base Wayland/Hyprland ---
    NIXOS_OZONE_WL = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    DISPLAY = ""; # Desactiva X11 explícitamente

    # --- Debugging (Opcional) ---
    HYPRLAND_DEBUG = condVal enableHyprlandDebug "1" "0";
    WLR_DEBUG = condVal enableHyprlandDebug "render" "";
    # HYPRLAND_LOG_WLR = condVal enableHyprlandDebug "1" "0"; # Opciones adicionales de debug
    # HYPRLAND_NO_CURSORWARP = condVal enableHyprlandDebug "1" "0";

    # --- Configuración Renderizador Wayland (WLR) ---
    WLR_BACKEND = "vulkan";
    WLR_RENDERER = "vulkan";
    WLR_NO_HARDWARE_CURSORS = "1"; # Puede mejorar compatibilidad
    # Las siguientes son para compatibilidad, mantenlas si resuelven problemas:
    WLR_DRM_NO_ATOMIC = "1";
    WLR_DRM_NO_MODIFIERS = "1";

    # --- Configuración Vulkan Específica AMD (RADV) ---
    AMD_VULKAN_ICD = condVal isAmdGpu "RADV" ""; # Forza RADV
    VK_ICD_FILENAMES = condVal isAmdGpu vulkanIcdPath "";
    WINE_VK_ICD_FILENAMES = condVal isAmdGpu vulkanIcdPath "";

    # --- Configuración OpenGL/Mesa ---
    MESA_LOADER_DRIVER_OVERRIDE = condVal isAmdGpu "radeonsi" ""; # Driver OpenGL para AMD
    LIBVA_DRIVER_NAME = condVal isAmdGpu "radeonsi" ""; # Aceleración de video VA-API
    VDPAU_DRIVER = condVal isAmdGpu "radeonsi" ""; # Aceleración de video VDPAU
    #__GL_THREADED_OPTIMIZATIONS = "1"; # Activado por defecto en Mesa moderno, pero no hace daño dejarlo
    MESA_GL_VERSION_OVERRIDE = "4.6"; # Considera quitarlo si no tienes problemas con juegos antiguos

    # --- Sincronización de Pantalla ---
    # __GL_GSYNC_ALLOWED = "0"; # Generalmente no necesario desactivar GSync explícitamente
    # __GL_VRR_ALLOWED = "0";   # Wayland/Hyprland gestionan VRR, esto es más para X11/Nvidia
    # Opciones: "immediate" (menor latencia, tearing), "fifo" (vsync, más latencia), "mailbox" (adaptativo, buen balance)
    MESA_VK_WSI_PRESENT_MODE = "mailbox"; # Recomendado como punto de partida balanceado

    # --- Optimizaciones RADV ---
    # "gpl": Graphics Pipeline Library, mejora tiempos de carga de shaders. "aco": Compilador alternativo.
    RADV_PERFTEST = "gpl,aco"; # Flags de rendimiento más estables y beneficiosos
    # RADV_DEBUG = ""; # Quitado, usar solo si un juego específico tiene glitches conocidos que se arreglan con flags
    RADV_TEX_ANISO = "16"; # Forzar filtro anisotrópico 16x para mejor calidad visual

    # --- Optimizaciones Específicas Steam/Proton/Wine ---
    STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "1"; # Usa librerías más nuevas de NixOS (generalmente bueno)
    STEAM_RUNTIME_HEAVY = "1"; # Puede ayudar con compatibilidad en algunos juegos
    DXVK_ASYNC = "1"; # Reduce stuttering compilando shaders en segundo plano (puede causar pop-in visual leve)
    PROTON_FORCE_LARGE_ADDRESS_AWARE = "1"; # Para juegos 32-bit que necesitan más de 2GB RAM
    #DXVK_HUD = "fps"; # Muestra FPS básicos con DXVK (MangoHud es más completo)

    # --- Configuración de Plataformas UI (Forzar Wayland) ---
    GDK_BACKEND = "wayland,x11"; # Permite fallback a X11 si Wayland falla para GTK
    QT_QPA_PLATFORM = "wayland;xcb"; # Permite fallback a X11 para Qt
    QT_AUTO_SCREEN_SCALE_FACTOR = "1"; # Ajusta según necesites para HiDPI si enableHiDPI=false
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # Para Hyprland
    SDL_VIDEODRIVER = "wayland,x11"; # Permite fallback a X11 para SDL2
    CLUTTER_BACKEND = "wayland";

    # --- Configuración de Aplicaciones Específicas ---
    MOZ_ENABLE_WAYLAND = "1"; # Firefox en Wayland
    # MOZ_WEBRENDER = "1"; # Activado por defecto
    # MOZ_USE_XINPUT2 = "1"; # Relevante para X11
    _JAVA_AWT_WM_NONREPARENTING = "1"; # Para apps Java Swing en WMs non-reparenting como Hyprland
    # _JAVA_OPTIONS = "..."; # Manten tus opciones si usas apps Java que las necesiten
    ANKI_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland"; # Para apps Electron

    # --- Configuración Audio (Pipewire) ---
    # Estas variables suelen ser gestionadas por Pipewire/Wireplumber automáticamente.
    # Solo inclúyelas si tienes problemas específicos de detección de audio.
    # PULSE_SERVER = "unix:/run/user/1000/pulse/native";
    SDL_AUDIODRIVER = "pipewire,pulse"; # Prioriza pipewire, permite fallback
    # ALSA_CONFIG_PATH = "..."; # Normalmente no necesario

    # --- XDG Base Directory ---
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # --- HiDPI Scaling ---
    GDK_SCALE = condVal enableHiDPI "2" "1";
    GDK_DPI_SCALE = condVal enableHiDPI "0.5" "1";
    QT_SCALE_FACTOR = condVal enableHiDPI "2" "1";
  };
}
