{ ... }:
{
  home.sessionVariables = {
    # ===== CONFIGURACIÓN BASE WAYLAND =====
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    WAYLAND_DISPLAY = "wayland-1";
    
    # ===== DRIVER AMD RADV OPTIMIZADO =====
    # Forzar uso de RADV en modo máximo rendimiento
    AMD_VULKAN_ICD = "RADV";
    RADV_PERFTEST = "aco,llvm,nir_lower_gs,sam,rt,gpl,nggc";
    RADV_DEBUG = "nohiz,novrsflatshading";
    # Configuración agresiva de performance
    MESA_VK_DEVICE_SELECT = "10de:*,1002:*"; # Priorizar GPUs discretas
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    
    # ===== OPTIMIZACIONES VULKAN =====
    WLR_RENDERER = "vulkan";
    WLR_BACKEND = "vulkan";
    VK_LAYER_PATH = "/run/opengl-driver/share/vulkan/explicit_layer.d";
    ENABLE_VKBASALT = 1;
    
    # ===== CONFIGURACIÓN GAMING ESPECÍFICA =====
    # Desactivar compositing para mejor rendimiento
    __GL_SYNC_TO_VBLANK = 0;
    __GL_GSYNC_ALLOWED = 0;
    __GL_VRR_ALLOWED = 0;
    vblank_mode = 0;
    
    # Prioridad de scheduling para gaming
    WINE_RT_POLICY = "FIFO";
    WINE_RT_PRIORITY = 15;
    
    # ===== CONFIGURACIÓN ESPECÍFICA RX 5500 XT (4GB VRAM) =====
    # Optimizaciones para GPU con memoria limitada
    RADV_FORCE_FAMILY = "gfx1012"; # RX 5500 XT específico (Navi 14)
    
    # Gestión agresiva de memoria VRAM
    MESA_VK_DEVICE_SELECT_FORCE_DEFAULT_DEVICE = "1";
    RADV_TEX_ANISO = "-1"; # Desactivar anisotropía forzada para ahorrar VRAM
    
    # Configuración conservadora para 4GB VRAM
    VK_MEMORY_DECOMPRESSION_METHOD = "copy";
    RADV_INVARIANT_GEOM = "1"; # Estabilidad en geometría compleja
    MESA_GLTHREAD = "true";
    mesa_glthread = "true";
    
    # ===== JAVA OPTIMIZADO PARA MINECRAFT =====
    # Configuración específica para Minecraft y aplicaciones Java
    _JAVA_AWT_WM_NONREPARENTING = 1;
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true -Dsun.java2d.opengl=true -Dsun.java2d.d3d=false";
    JAVA_FONTS = "/run/current-system/sw/share/X11/fonts";
    
    # Optimizaciones específicas para Minecraft
    MINECRAFT_JAVA_ARGS = "-XX:+UnlockExperimentalVMOptions -XX:+UseG1GC -XX:G1NewSizePercent=20 -XX:G1ReservePercent=20 -XX:MaxGCPauseMillis=50 -XX:G1HeapRegionSize=32M -XX:+UseStringDeduplication -XX:+UseFastUnorderedTimeStamps -XX:+UseCriticalJavaThreadPriority";
    
    # ===== SDL Y GAMING FRAMEWORKS =====
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
    DISABLE_QT5_COMPAT = 0;
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
    
    # ===== CONFIGURACIONES WLR ESPECÍFICAS =====
    WLR_DRM_NO_ATOMIC = 1;
    WLR_NO_HARDWARE_CURSORS = 1;
    WLR_USE_LIBINPUT = 1;
    
    # ===== HERRAMIENTAS DEL SISTEMA =====
    GRIMBLAST_HIDE_CURSOR = 0;
    DIRENV_LOG_FORMAT = "";
    
    # ===== OPTIMIZACIONES DE PERFORMANCE ADICIONALES =====
    # Scheduler del kernel optimizado para gaming
    SCHED_BATCH = 1;
    
    # Configuración de prioridades de proceso
    GAMING_PRIORITY = "high";
    
    # Optimizaciones de I/O
    IOSCHEDULER = "mq-deadline";
    
    # ===== STEAM Y GAMING PLATFORMS =====
    STEAM_FORCE_DESKTOPUI_SCALING = 1;
    PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_DATA_HOME/Steam";
    
    # ===== CONFIGURACIÓN EXPERIMENTAL AJUSTADA PARA RX 5500 XT =====
    # Variables conservadoras para GPU con 4GB VRAM
    RADV_FORCE_VRS = "1x1"; # VRS conservador para preservar VRAM
    ACO_DEBUG = "validateir"; # Validación mínima para mejor rendimiento
    MESA_DISK_CACHE_SINGLE_FILE = "true";
    
    # Configuración específica para RDNA1 (RX 5500 XT)
    RADV_DISABLE_HTILE = "1"; # Desactivar HTILE en RDNA1 para estabilidad
    RADV_DISABLE_DCC = "0"; # Mantener DCC habilitado para mejor rendimiento
  };
}
