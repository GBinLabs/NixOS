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
      evolution-data-server.enable = lib.mkForce false;
      gnome-browser-connector.enable = false;
      gnome-initial-setup.enable = false;
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
