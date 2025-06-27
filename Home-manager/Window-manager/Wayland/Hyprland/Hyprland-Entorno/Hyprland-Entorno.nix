{ ... }:
{
  # Variables de entorno optimizadas para máximo FPS
    home.sessionVariables = {
      # ===== CONFIGURACIÓN BASE WAYLAND =====
      XDG_CURRENT_DESKTOP = "Hyprland";
      XDG_SESSION_TYPE = "wayland";
      XDG_SESSION_DESKTOP = "Hyprland";
      
      # ===== DRIVER AMD RADV OPTIMIZADO =====
      # Solo RADV para máximo rendimiento
      AMD_VULKAN_ICD = "RADV";
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
      
      # Optimizaciones específicas RX 5500 XT (RDNA1)
      RADV_PERFTEST = "aco"; # Solo ACO compiler para mejor rendimiento
      RADV_FORCE_FAMILY = "gfx1012"; # RX 5500 XT específico
      
      # ===== CONFIGURACIÓN GAMING MÁXIMO RENDIMIENTO =====
      # Eliminar limitaciones de VSync y input lag
      __GL_SYNC_TO_VBLANK = 0;
      vblank_mode = 0;
      
      # Prioridad alta para gaming
      WINE_RT_POLICY = "FIFO";
      WINE_RT_PRIORITY = 15;
      
      # ===== GESTIÓN VRAM OPTIMIZADA (4GB) =====
      # Configuración conservadora para evitar bottlenecks
      MESA_VK_DEVICE_SELECT = "1002:*";
      MESA_VK_DEVICE_SELECT_FORCE_DEFAULT_DEVICE = "1";
      MESA_DISK_CACHE_SIZE = "512M"; # Reducido para 4GB VRAM
      MESA_DISK_CACHE_SINGLE_FILE = "true";
      
      # Optimizaciones de memoria
      RADV_TEX_ANISO = "-1"; # Desactivar para máximo FPS
      MESA_GLTHREAD = "true";
      
      # ===== CONFIGURACIÓN ESPECÍFICA RDNA1 =====
      # Habilitar funciones de rendimiento para RDNA1
      RADV_DISABLE_HTILE = "0";
      RADV_DISABLE_DCC = "0";
      
      # ===== SDL Y APLICACIONES =====
      SDL_VIDEODRIVER = "wayland,x11";
      
      # ===== APLICACIONES WAYLAND NATIVAS =====
      NIXOS_OZONE_WL = 1;
      MOZ_ENABLE_WAYLAND = 1;
      
      # ===== QT MINIMALISTA =====
      QT_QPA_PLATFORM = "wayland;xcb";
      QT_AUTO_SCREEN_SCALE_FACTOR = 1;
      
      # ===== GTK MINIMALISTA =====
      GDK_BACKEND = "wayland,x11";
      
      # ===== WINE PARA GAMING =====
      WINEARCH = "win64";
      WINEPREFIX = "$HOME/.wine";
      WINE_LARGE_ADDRESS_AWARE = 1;
      
      # ===== WLR CONFIGURACIÓN MÍNIMA =====
      WLR_DRM_NO_ATOMIC = 0;
      WLR_NO_HARDWARE_CURSORS = 0;
      WLR_USE_LIBINPUT = 1;
      
      # ===== STEAM GAMING =====
      STEAM_FORCE_DESKTOPUI_SCALING = 1;
      PRESSURE_VESSEL_FILESYSTEMS_RW = "$XDG_DATA_HOME/Steam";
      
      # ===== COUNTER-STRIKE 2 ESPECÍFICAS =====
      # Variables para máximo rendimiento en CS2
      RADV_DEBUG = ""; # Limpiar debug para rendimiento
      ACO_DEBUG = ""; # Limpiar debug ACO
      
      # Configuración específica para Source 2 engine
      SOURCE2_VULKAN_ENABLE = "1";
    };
}
