{pkgs,...}:
{
  home.sessionVariables = {

    ### Wayland / Hyprland ###
    XDG_SESSION_TYPE                     = "wayland";
    XDG_CURRENT_DESKTOP                  = "Hyprland";
    XDG_SESSION_DESKTOP                  = "Hyprland";
    NIXOS_OZONE_WL                       = "1";

    ### Hyprland debug ###
    HYPRLAND_DEBUG                       = "0";
    WLR_DEBUG                            = "";

    ### Backend de renderizado ###
    WLR_BACKEND                          = "vulkan";
    WLR_RENDERER                         = "vulkan";
    WLR_NO_HARDWARE_CURSORS              = "1";
    WLR_DRM_NO_ATOMIC                    = "1";
    WLR_DRM_NO_MODIFIERS                 = "1";

    ### Vulkan ICD ###
    VK_ICD_FILENAMES                     = "${pkgs.vulkan-loader}/share/vulkan/icd.d";
    WINE_VK_ICD_FILENAMES                = "${pkgs.vulkan-loader}/share/vulkan/icd.d";

    ### Mesa / sincronización ###
    vblank_mode                          = "0";       # deshabilita vsync a nivel driver
    MESA_VK_WSI_PRESENT_MODE             = "mailbox"; # baja latencia en Vulkan
    MESA_GLTHREAD                        = "true";    # threading OpenGL para CPU multicore
    MESA_NO_ERROR                        = "1";       # elimina comprobaciones GL en runtime
    MESA_GL_VERSION_OVERRIDE             = "4.6";     # forzar perfil GL moderno

    ### RADV (Vulkan en AMD) ###
    RADV_PERFTEST                        = "gpl,nggc";  # pipelines precompilados + culling avanzado
    RADV_DEBUG                           = "";          # sin debug
    VKD3D_CONFIG                         = "noop";      # reduce efectos en DX12 (opcional)

    ### DXVK ###
    DXVK_ASYNC                           = "1";        # compilación de shaders en background
    DXVK_HUD                             = "frametimes";# HUD de frametimes (opcional)

    ### Proton / Steam ###
    PROTON_USE_WAYLAND                   = "1";  # intenta capa Wayland en Proton
    PROTON_FORCE_LARGE_ADDRESS_AWARE     = "1";
    STEAM_RUNTIME_PREFER_HOST_LIBRARIES  = "1";
    STEAM_RUNTIME_HEAVY                  = "1";

    ### MangoHud & GameMode ###
    ENABLE_VKBASALT                      = "0";
    GAMEMODE_AUTO_LAUNCH                 = "1";

    ### Fallback toolkits ###
    GDK_BACKEND                          = "wayland,x11";
    QT_QPA_PLATFORM                     = "wayland;xcb";
    QT_AUTO_SCREEN_SCALE_FACTOR          = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION  = "1";
    SDL_VIDEODRIVER                      = "wayland,x11";
    ELECTRON_OZONE_PLATFORM_HINT         = "wayland";
    MOZ_ENABLE_WAYLAND                   = "1";
    _JAVA_AWT_WM_NONREPARENTING          = "1";

    ### Audio (PipeWire) ###
    SDL_AUDIODRIVER                      = "pipewire";

    ### Java (Minecraft y otros) ###
    _JAVA_OPTIONS                        = "-XX:+UseG1GC -XX:+UnlockExperimentalVMOptions -XX:MaxGCPauseMillis=20";
    JAVA_TOOL_OPTIONS                    = "-Dsun.java2d.opengl=true";

    ### XDG Base Directory ###
    XDG_CONFIG_HOME                      = "$HOME/.config";
    XDG_CACHE_HOME                       = "$HOME/.cache";
    XDG_DATA_HOME                        = "$HOME/.local/share";
    XDG_STATE_HOME                       = "$HOME/.local/state";
  };
}

