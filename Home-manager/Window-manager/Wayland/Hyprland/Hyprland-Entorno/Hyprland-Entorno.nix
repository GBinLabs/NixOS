{ ... }:
{
  home.sessionVariables = {
    # ===== CONFIGURACIÓN BASE WAYLAND =====
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    WAYLAND_DISPLAY = "wayland-1";
    
    # ===== DRIVER AMD RADV OPTIMIZADO PARA GAMESCOPE =====
    # Configuración estable y compatible
    AMD_VULKAN_ICD = "RADV";
    RADV_PERFTEST = "aco,llvm,sam"; # Eliminadas opciones experimentales problemáticas
    # RADV_DEBUG eliminado - causaba conflictos con Gamescope
    
    # Configuración optimizada para RX 5500 XT (4GB VRAM)
    RADV_FORCE_FAMILY = "gfx1012"; # RX 5500 XT específico (Navi 14)
    MESA_VK_DEVICE_SELECT = "1002:*"; # Priorizar AMD GPU
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    
    # ===== CONFIGURACIÓN VULKAN COMPATIBLE CON GAMESCOPE =====
    # WLR_RENDERER removido - Gamescope maneja su propio renderer
    # WLR_BACKEND removido - Conflicto con Gamescope
    VK_LAYER_PATH = "/run/opengl-driver/share/vulkan/explicit_layer.d";
    ENABLE_VKBASALT = 0; # Deshabilitado para evitar conflictos
    
    # ===== CONFIGURACIÓN GAMING ESTABLE =====
    # Configuración conservadora para estabilidad
    __GL_SYNC_TO_VBLANK = 0;
    vblank_mode = 0;
    
    # Prioridad de scheduling moderada
    WINE_RT_POLICY = "FIFO";
    WINE_RT_PRIORITY = 10; # Reducido de 15 para mayor estabilidad
    
    # ===== GESTIÓN DE MEMORIA VRAM CONSERVADORA =====
    # Configuración estable para 4GB VRAM
    MESA_VK_DEVICE_SELECT_FORCE_DEFAULT_DEVICE = "1";
    RADV_TEX_ANISO = "-1"; # Desactivar anisotropía forzada
    
    # Configuración de estabilidad
    VK_MEMORY_DECOMPRESSION_METHOD = "copy";
    RADV_INVARIANT_GEOM = "1";
    MESA_GLTHREAD = "true";
    mesa_glthread = "true";
    
    # ===== CONFIGURACIÓN MEJORADA PARA RDNA1 =====
    # Optimizaciones específicas para RX 5500 XT
    RADV_DISABLE_HTILE = "0"; # Habilitado para mejor rendimiento
    RADV_DISABLE_DCC = "0"; # Habilitado para rendimiento
    
    # ===== JAVA OPTIMIZADO PARA MINECRAFT =====
    _JAVA_AWT_WM_NONREPARENTING = 1;
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.opengl=true";
    JAVA_FONTS = "/run/current-system/sw/share/X11/fonts";
    
    # Optimizaciones conservadoras para Minecraft
    MINECRAFT_JAVA_ARGS = "-XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=16M";
    
    # ===== SDL COMPATIBLE CON GAMESCOPE =====
    SDL_VIDEODRIVER = "wayland,x11";
    SDL_DYNAMIC_API = "/run/current-system/sw/lib/libSDL2.so";
    
    # ===== APLICACIONES WAYLAND NATIVAS =====
    NIXOS_OZONE_WL = 1;
    MOZ_ENABLE_WAYLAND = 1;
    MOZ_USE_XINPUT2 = 1;
    MOZ_DBUS_REMOTE = 1;
    ANKI_WAYLAND = 1;
    
    # ===== QT OPTIMIZADO =====
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_AUTO_SCREEN_SCALE_FACTOR = 1;
    QT_WAYLAND_DISABLE_WINDOWDECORATION = 1;
    QT_QPA_PLATFORMTHEME = "qt5ct";
    QT_STYLE_OVERRIDE = "kvantum";
    QT_WAYLAND_FORCE_DPI = "96";
    
    # ===== GTK OPTIMIZADO =====
    GDK_BACKEND = "wayland,x11";
    GDK_SCALE = 1;
    GDK_DPI_SCALE = 1;
    
    # ===== CLUTTER Y FRAMEWORKS GRÁFICOS =====
    CLUTTER_BACKEND = "wayland";
    COGL_DRIVER = "gl3";
    
    # ===== WINE Y COMPATIBILIDAD GAMING =====
    WINEARCH = "win64";
    WINEPREFIX = "$HOME/.wine";
    WINE_LARGE_ADDRESS_AWARE = 1;
    
    # ===== CONFIGURACIONES WLR BÁSICAS =====
    # Configuración mínima para evitar conflictos con Gamescope
    WLR_DRM_NO_ATOMIC = 0; # Cambiado a 0 para mejor compatibilidad
    WLR_NO_HARDWARE_CURSORS = 0; # Cambiado a 0 para mejor rendimiento
    WLR_USE_LIBINPUT = 1;
    
    # ===== HERRAMIENTAS DEL SISTEMA =====
    GRIMBLAST_HIDE_CURSOR = 0;
    DIRENV_LOG_FORMAT = "";
    
    # ===== STEAM Y GAMING PLATFORMS =====
    STEAM_FORCE_DESKTOPUI_SCALING = 1;
    PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_DATA_HOME/Steam";
    
    # ===== GAMESCOPE ESPECÍFICAS =====
    # Variables específicas para mejorar compatibilidad con Gamescope
    GAMESCOPE_WAYLAND_DISPLAY = "gamescope-0";
    
    # ===== CONFIGURACIÓN VULKAN ESPECÍFICA PARA GAMING =====
    # Configuración balanceada para rendimiento y estabilidad
    VK_DRIVER_FILES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    
    # ===== CONFIGURACIÓN DE CACHE Y RENDIMIENTO =====
    MESA_DISK_CACHE_SINGLE_FILE = "true";
    MESA_DISK_CACHE_SIZE = "1024M"; # Tamaño apropiado para 4GB VRAM
    
    # ===== CONFIGURACIÓN EXPERIMENTAL CONSERVADORA =====
    # Solo opciones probadas y estables
    ACO_DEBUG = "validateir";
    
    # ===== CONFIGURACIÓN DE COMPATIBILIDAD =====
    # Mejoras para aplicaciones que no son nativas de Wayland
    DISABLE_QT5_COMPAT = 0;
  };
}
