# =============================================================================
# Configuración de Entorno Optimizada para Gaming en NixOS + Hyprland + AMD(RADV)
# =============================================================================
# Objetivo: Maximizar rendimiento y compatibilidad para juegos (Steam/Proton/Wine)
#           y Gamescope, usando Hyprland y drivers RADV en una GPU AMD.
# Autor: Gemini (basado en mejores prácticas y optimizaciones conocidas)
# Fecha: 2025-05-02 (Adaptar según sea necesario)
# =============================================================================
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

    # -------------------------------------------------------------------------
    # Configuración Vulkan General & AMD
    # -------------------------------------------------------------------------
    # Selecciona explícitamente RADV si AMDVLK también estuviera instalado
    AMD_VULKAN_ICD = "RADV";

    # NOTA: VK_ICD_FILENAMES se omite intencionalmente.
    # En NixOS, es preferible depender de la configuración del sistema
    # (gestionada por hardware.opengl.* en configuration.nix) para que
    # vulkan-loader encuentre los drivers correctos instalados en el Nix store
    # (usualmente en /run/opengl-driver/share/vulkan/icd.d).
    # Establecerlo manualmente aquí puede causar conflictos o ignorar la config del sistema.

    # -------------------------------------------------------------------------
    # Optimizaciones MESA (OpenGL / Vulkan Común)
    # -------------------------------------------------------------------------
    vblank_mode = "0"; # Deshabilitar VSync a nivel driver Mesa (app/compositor gestionan)
    MESA_GLTHREAD = "true"; # Habilitar multi-hilo para OpenGL (beneficia CPU-bound & DXVK)
    MESA_NO_ERROR = "1"; # Deshabilitar chequeo de errores GL/VK (ligero boost, oculta errores)

    # Opcional: Aumentar tamaño máximo caché de shaders en disco (Default suele ser 1GB)
    # MESA_SHADER_CACHE_MAX_SIZE = "5G"; # Ejemplo: 5 Gigabytes

    # Opcional: Usar un único archivo como base de datos para caché (puede ser mejor en algunos FS/HDDs)
    # MESA_DISK_CACHE_DATABASE = "1";

    # -------------------------------------------------------------------------
    # Optimizaciones RADV (Driver Vulkan AMD Específico)
    # -------------------------------------------------------------------------
    # Habilitar optimizaciones RADV: ACO (shader compiler), GPL (Graphics Pipeline Library), NGGC (Next-Gen Geometry Culling)
    # ACO es default ahora, pero lo incluimos para ser explícitos.
    RADV_PERFTEST = "aco,gpl,nggc";
    RADV_DEBUG = ""; # Asegurar que el debug esté deshabilitado

    # Optimización potencial para juegos UE4/UE5 (mejora orden renderizado de capas Multiple Render Target)
    RADV_ENABLE_MRT_LAYER_ORDERING = "true";

    # -------------------------------------------------------------------------
    # Optimizaciones DXVK (DirectX 9/10/11 -> Vulkan)
    # -------------------------------------------------------------------------
    DXVK_ASYNC = "1"; # Compilación asíncrona de shaders (reduce stutter)
    DXVK_LOG_LEVEL = "none"; # Deshabilitar logs de DXVK para mínimo overhead

    # -------------------------------------------------------------------------
    # Optimizaciones VKD3D-Proton (DirectX 12 -> Vulkan)
    # -------------------------------------------------------------------------
    VKD3D_DEBUG = "none"; # Deshabilitar logs de VKD3D para mínimo overhead
    # VKD3D_CONFIG          = "";     # Descomentar y añadir flags si un juego DX12 específico lo necesita

    # -------------------------------------------------------------------------
    # Configuración Proton & Steam
    # -------------------------------------------------------------------------
    PROTON_USE_WAYLAND = "1"; # Intentar usar backend Wayland nativo (puede requerir "0" para juegos problemáticos)
    PROTON_FORCE_LARGE_ADDRESS_AWARE = "1"; # Permitir a juegos 32-bit usar más de 2GB de RAM
    PROTON_ENABLE_NVAPI = "1"; # Habilitar stubs NVAPI (necesario para algunos juegos/features como DLSS incluso en AMD)
    PROTON_ENABLE_NGX_UPDATER = "0"; # Deshabilitar updater de DLSS (no aplica a AMD)
    PROTON_LOG = "0"; # Deshabilitar logs de Proton (poner "1" para diagnosticar)

    # ¡PRECAUCIÓN! Prefiere bibliotecas del host (NixOS) sobre las del runtime de Steam.
    # A menudo NECESARIO para Wayland, Pipewire, drivers Mesa actualizados en NixOS,
    # pero PUEDE causar conflictos si hay incompatibilidad de versiones ABI.
    STEAM_RUNTIME_PREFER_HOST_LIBRARIES = "1";

    # Usa una versión más "pesada" del runtime, incluyendo más bibliotecas como GTK2, etc.
    STEAM_RUNTIME_HEAVY = "1";

    # -------------------------------------------------------------------------
    # Utilidades Gaming & Misceláneos
    # -------------------------------------------------------------------------
    GAMEMODE_AUTO_LAUNCH = "1"; # Habilitar Feral GameMode automáticamente (si está instalado)
    ENABLE_VKBASALT = "0"; # Deshabilitar vkBasalt (post-procesado) globalmente
    MANGOHUD = "0"; # Deshabilitar MangoHud globalmente (habilitar per-game con `mangohud %command%`)

    # Evita que juegos SDL minimicen al perder foco (útil en Tiling WMs)
    SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS = "0";

    # -------------------------------------------------------------------------
    # Configuración de Toolkits UI (Preferencia Wayland)
    # -------------------------------------------------------------------------
    GDK_BACKEND = "wayland,x11"; # GTK
    QT_QPA_PLATFORM = "wayland;xcb"; # Qt5/Qt6
    QT_AUTO_SCREEN_SCALE_FACTOR = "1"; # Evitar auto-escalado Qt
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1"; # Mejor integración Qt en Tiling WMs
    SDL_VIDEODRIVER = "wayland,x11"; # SDL2
    # Forma moderna para Electron (preferida sobre NIXOS_OZONE_WL si la app la soporta)
    ELECTRON_OZONE_PLATFORM_HINT = "auto"; # 'auto' suele preferir wayland si está disponible
    MOZ_ENABLE_WAYLAND = "1"; # Firefox

    # -------------------------------------------------------------------------
    # Audio (PipeWire)
    # -------------------------------------------------------------------------
    SDL_AUDIODRIVER = "pipewire"; # Preferir PipeWire para SDL

    # -------------------------------------------------------------------------
    # Java (Si aplica)
    # -------------------------------------------------------------------------
    _JAVA_AWT_WM_NONREPARENTING = "1"; # Arreglo común para GUIs Java en Tiling WMs
    JAVA_TOOL_OPTIONS = "-Dsun.java2d.opengl=true"; # Aceleración H/W para Java2D

    # -------------------------------------------------------------------------
    # XDG Base Directory (Organización y buenas prácticas)
    # -------------------------------------------------------------------------
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };
}
# =============================================================================
# Notas Finales:
# 1. Aplicar cambios: Ejecuta `home-manager switch` y reinicia tu sesión.
# 2. Troubleshooting: Si un juego o Gamescope falla, prueba comentando
#    temporalmente variables "agresivas" como `PROTON_USE_WAYLAND=1` o
#    `STEAM_RUNTIME_PREFER_HOST_LIBRARIES=1`.
# 3. Rendimiento vs Estabilidad: Algunas optimizaciones pueden ser ligeramente
#    menos estables en ciertos escenarios. Ajusta según tu experiencia.
# 4. Dependencias: Asegúrate de tener instalados los paquetes relevantes en
#    NixOS (mesa, vulkan-loader, vulkan-tools, gamescope, gamemode, etc.)
#    y que `hardware.opengl.enable = true;` (y `driSupport32Bit` si juegas
#    a juegos 32bit) esté en tu configuration.nix.
# =============================================================================

