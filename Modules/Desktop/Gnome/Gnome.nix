{
  lib,
  pkgs,
  ...
}: {
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
      evolution-data-server.enable = lib.mkForce false;
      gnome-browser-connector.enable = false;
      gnome-initial-setup.enable = false;
    };
  };

  hardware.bluetooth.powerOnBoot = false;

  environment = {
    gnome.excludePackages = [pkgs.gnome-tour pkgs.gnome-user-docs];
    systemPackages = with pkgs; [
      adwaita-icon-theme
      gnome-themes-extra
    ];
    shells = with pkgs; [zsh];
  };

  fonts = {
    packages = with pkgs; [
      inter
      jetbrains-mono
      noto-fonts
      noto-fonts-color-emoji
      liberation_ttf
      nerd-fonts.jetbrains-mono
    ];

    fontconfig = {
      defaultFonts = {
        sansSerif = ["Inter"];
        serif = ["Liberation Serif"];
        monospace = ["JetBrains Mono"];
        emoji = ["Noto Color Emoji"];
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

  environment.sessionVariables = {
    WAYLAND_DISPLAY = "wayland-0";
    XDG_SESSION_TYPE = "wayland";
    GDK_BACKEND = "wayland";
    QT_QPA_PLATFORM = "wayland";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
    _JAVA_OPTIONS = "-Dawt.useSystemAAFontSettings=on -Dswing.aatext=true";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DBUS_REMOTE = "1";
    CLUTTER_BACKEND = "wayland";
    EGL_PLATFORM = "wayland";
  };
}
