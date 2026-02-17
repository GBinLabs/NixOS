_: {
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland = {
        enable = true;
      };
    };
    silentSDDM = {
      enable = true;
      theme = "default";
    };
  };

  environment.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    GDK_BACKEND = "wayland";
    CLUTTER_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_WEBRENDER = "1";
    MOZ_ACCELERATED = "1";
    AMD_VULKAN_ICD = "RADV";
    RADV_PERFTEST = "gpl,rt,ngg_culling,sam";
    MESA_DISK_CACHE_SINGLE_FILE = "1";
    MESA_SHADER_CACHE_MAX_SIZE = "10G";
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";
    __GL_THREADED_OPTIMIZATIONS = "1";
    mesa_glthread = "true";
  };
}
