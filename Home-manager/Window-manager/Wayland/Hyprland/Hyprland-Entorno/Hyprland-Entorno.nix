{
  pkgs,
  lib,
  ...
}: let
  # Core configuration parameters
  enableHyprlandDebug = false; # Set to true for debugging output
  isAmdGpu = true; # Set to false for NVIDIA or Intel GPUs
  enableHiDPI = false; # Set to true for high-resolution displays

  # Resource paths
  vulkanPackage = pkgs.vulkan-loader;
  vulkanIcdPath = "${vulkanPackage}/share/vulkan/icd.d/radeon_icd.x86_64.json";

  # Helper function to set conditional values with defaults
  condVal = condition: valueIfTrue: valueIfFalse:
    if condition
    then valueIfTrue
    else valueIfFalse;
in {
  home.sessionVariables = {
    # System environment configuration
    NIXOS_OZONE_WL = "1";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    DISPLAY = "";  # Desactiva la variable DISPLAY para prevenir el uso de X11

    # Hyprland debugging (always defined)
    HYPRLAND_DEBUG = condVal enableHyprlandDebug "1" "0";
    WLR_DEBUG = condVal enableHyprlandDebug "render" "";

    # Vulkan rendering configuration
    WLR_BACKEND = "vulkan";
    WLR_RENDERER = "vulkan";
    WLR_NO_HARDWARE_CURSORS = "1";
    WLR_DRM_NO_ATOMIC = "1";
    WLR_DRM_NO_MODIFIERS = "1";  # Mejora la compatibilidad con algunos juegos

    # AMD-specific Vulkan configuration
    AMD_VULKAN_ICD = condVal isAmdGpu "RADV" "";
    VK_ICD_FILENAMES = condVal isAmdGpu vulkanIcdPath "";
    WINE_VK_ICD_FILENAMES = condVal isAmdGpu vulkanIcdPath "";

    # OpenGL/Mesa configuration
    MESA_LOADER_DRIVER_OVERRIDE = condVal isAmdGpu "radeonsi" "";
    LIBVA_DRIVER_NAME = condVal isAmdGpu "radeonsi" "";
    VDPAU_DRIVER = condVal isAmdGpu "radeonsi" "";
    MESA_GL_VERSION_OVERRIDE = "4.6";
    __GL_THREADED_OPTIMIZATIONS = "1";

    # Display synchronization settings
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    MESA_VK_WSI_PRESENT_MODE = "immediate";  # Menor latencia pero puede causar tearing

    # Java application support (optimizado para Minecraft)
    _JAVA_AWT_WM_NONREPARENTING = "1";
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.opengl=true -Dswing.defaultlaf=com.sun.java.swing.plaf.gtk.GTKLookAndFeel";
    MINECRAFT_WAYLAND = "1";

    # GTK configuration - solo Wayland
    GDK_BACKEND = "wayland";
    GTK_THEME = "Colloid-Green-Dark-Gruvbox";

    # Qt configuration - solo Wayland
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    DISABLE_QT5_COMPAT = "0";

    # Additional UI frameworks - solo Wayland
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";

    # Application-specific settings
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBRENDER = "1";
    MOZ_USE_XINPUT2 = "1";
    ANKI_WAYLAND = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";

    # Mejoras para juegos en Wayland nativo
    GAMESCOPE_WAYLAND = "1";
    WINE_FULLSCREEN_FSR = "1"; # Ayuda con el escalado en pantalla completa

    # Mejoras para RADV
    STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "1";
    RADV_PERFTEST = "gpl,aco,extended_prim_discard,bo_reuse"; # Optimizaciones para el compilador ACO
    RADV_DEBUG = "nohiz,nodcc"; # Puede mejorar el rendimiento en ciertos juegos
    RADV_TEX_ANISO = "16"; # Filtrado anisotrópico para mejor calidad visual

    # Optimizaciones específicas para Steam y Proton
    STEAM_RUNTIME_HEAVY = "1";
    STEAM_USE_MANGOAPP = "1";
    PROTON_ENABLE_NVAPI = "1";
    PROTON_HIDE_NVIDIA_GPU = "0";
    DRI_PRIME = "1";
    
    # Forzar Wayland nativo en Steam y juegos
    ENABLE_VKBASALT = "1";
    DXVK_ASYNC = "1";
    
    # Configuración de Proton
    PROTON_USE_WINED3D = "0";  # Usar DXVK en lugar de wined3d para mejor rendimiento
    PROTON_FORCE_LARGE_ADDRESS_AWARE = "1";  # Para juegos que necesitan acceder a más de 2GB de RAM
    DXVK_HUD = "fps";  # Mostrar FPS (opcional)
    
    # Forzar aplicaciones solo Wayland
    DISABLE_X11 = "1";
    WAYLAND_ONLY = "1";
    
    # Configuración de audio con Pipewire
    PULSE_SERVER = "unix:/run/user/1000/pulse/native";
    SDL_AUDIODRIVER = "pipewire";
    ALSA_CONFIG_PATH = "/usr/share/alsa/alsa.conf.d/50-pipewire.conf:/usr/share/alsa/alsa.conf.d/99-pipewire-default.conf";

    # XDG Base Directory specification
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    # Development environment
    DIRENV_LOG_FORMAT = "";

    # HiDPI scaling (always defined)
    GDK_SCALE = condVal enableHiDPI "2" "1";
    GDK_DPI_SCALE = condVal enableHiDPI "0.5" "1";
    QT_SCALE_FACTOR = condVal enableHiDPI "2" "1";

    # Additional debugging options (always defined)
    HYPRLAND_LOG_WLR = condVal enableHyprlandDebug "1" "0";
    HYPRLAND_NO_CURSORWARP = condVal enableHyprlandDebug "1" "0";
  };

  # Conditional package installation for AMD GPUs
  home.packages = lib.mkIf isAmdGpu [
    pkgs.mesa
    pkgs.libva-utils
    pkgs.vulkan-tools
    pkgs.amdvlk
    pkgs.vkbasalt
    #pkgs.protontricks
    #pkgs.winetricks
  ];
}
