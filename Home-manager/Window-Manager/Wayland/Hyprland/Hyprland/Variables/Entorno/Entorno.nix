{ ... }:
{
  home.sessionVariables = {
    GTK_THEME = "Nordic";
    QT_QPA_PLATFORMTHEME = "gtk2";
    
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    
    AMD_VULKAN_ICD = "RADV";
    VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
    
    RADV_PERFTEST = "aco,sam,rt,nggc";
    RADV_FORCE_FAMILY = "gfx1012";
    
    MESA_GLTHREAD = "true";
    MESA_NO_ERROR = "1";
    MESA_VK_DEVICE_SELECT = "1002:*";
    MESA_VK_DEVICE_SELECT_FORCE_DEFAULT_DEVICE = "1";
    
    MESA_DISK_CACHE_SIZE = "1024M";
    MESA_DISK_CACHE_SINGLE_FILE = "true";
    MESA_DISK_CACHE_DATABASE = "true";
    
    __GL_SYNC_TO_VBLANK = "0";
    vblank_mode = "0";
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";
    
    WINE_RT_POLICY = "FIFO";
    WINE_RT_PRIORITY = "15";
    
    RADV_DISABLE_HTILE = "0";
    RADV_DISABLE_DCC = "0";
    RADV_DISABLE_CMASK = "0";
    
    RADV_TEX_ANISO = "16";
    RADV_DISABLE_TRUNC_COORD = "0";
    
    STEAM_FORCE_DESKTOPUI_SCALING = "1";
    PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_DATA_HOME/Steam";
    
    WINEARCH = "win64";
    WINEPREFIX = "$HOME/.wine";
    WINE_LARGE_ADDRESS_AWARE = "1";
    DXVK_HUD = "0";
    DXVK_LOG_LEVEL = "none";
    
    VK_LAYER_PATH = "/run/opengl-driver/share/vulkan/explicit_layer.d";
    VULKAN_SDK = "/run/opengl-driver";
    
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBRENDER = "1";
    
    SDL_VIDEODRIVER = "wayland";
    SDL_AUDIODRIVER = "pipewire";
    
    QT_QPA_PLATFORM = "wayland";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    
    GDK_BACKEND = "wayland";
    GDK_SCALE = "1";
    
    WLR_DRM_NO_ATOMIC = "0";
    WLR_NO_HARDWARE_CURSORS = "0";
    WLR_USE_LIBINPUT = "1";
    WLR_RENDERER_ALLOW_SOFTWARE = "0";
    
    SOURCE2_VULKAN_ENABLE = "1";
    RADV_DEBUG = "";
    ACO_DEBUG = "";
    
    __GL_THREADED_OPTIMIZATIONS = "1";
    __GL_SHADER_DISK_CACHE = "1";
    __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
    
    MALLOC_CHECK_ = "0";
    MALLOC_PERTURB_ = "0";

    GLFW_PLATFORM = "wayland";
    
    GOVERNOR = "performance";
  };
}
