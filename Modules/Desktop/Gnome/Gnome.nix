{
  lib,
  pkgs,
  ...
}:
{
  services = {
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
        banner = "¡Hola!";
        autoSuspend = true;
        debug = false;
      };
      defaultSession = "gnome";
    };
    desktopManager.gnome.enable = true;
    gnome = {
      core-apps.enable = false;
      localsearch.enable = false;
      tinysparql.enable = false;
    };
  };

  environment = {
    gnome.excludePackages = [
      pkgs.gnome-tour
      pkgs.gnome-user-docs
    ];
    systemPackages = with pkgs; [
      adwaita-icon-theme
      gnome-themes-extra
    ];
    shells = with pkgs; [ zsh ];
    sessionVariables = {
      # === WAYLAND NATIVO ===
      GDK_BACKEND = "wayland";
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      CLUTTER_BACKEND = "wayland";
      MOZ_ENABLE_WAYLAND = "1";
      NIXOS_OZONE_WL = "1";
      ELECTRON_OZONE_PLATFORM_HINT = "wayland";

      # === RADV/MESA CON ANTI-LAG 2.0 ===
      AMD_VULKAN_ICD = "RADV";
      RADV_PERFTEST = "nggc,sam,rt,antilag2";
      MESA_GLTHREAD = "true";
      VK_INSTANCE_LAYERS = "VK_LAYER_MESA_anti_lag";

      # === PROTON/WINE ===
      PROTON_ENABLE_NVAPI = "1";
      WINEFSYNC = "1";
      PROTON_ENABLE_NTSYNC = "1";
      PROTON_ENABLE_WAYLAND = "1";

      # === VRR/FREESYNC ===
      __GL_GSYNC_ALLOWED = "1";
      __GL_VRR_ALLOWED = "1";
    };
  };

  fonts = {
    packages = with pkgs; [
      inter
      jetbrains-mono
      noto-fonts
      noto-fonts-color-emoji
      liberation_ttf
      nerd-fonts.jetbrains-mono
      times-newer-roman
    ];

    fontconfig = {
      defaultFonts = {
        sansSerif = [ "Inter" ];
        serif = [ "Liberation Serif" ];
        monospace = [ "JetBrains Mono" ];
        emoji = [ "Noto Color Emoji" ];
      };

      antialias = true;
      hinting = {
        enable = true;
        style = "slight";
      };
      subpixel.rgba = "rgb";
      cache32Bit = true;
    };
  };
}
