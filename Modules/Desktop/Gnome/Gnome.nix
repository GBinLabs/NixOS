# Modules/Desktop/Gnome/Gnome.nix
{pkgs, ...}: {
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

  hardware.bluetooth.powerOnBoot = false;

  environment = {
    gnome.excludePackages = [pkgs.gnome-tour];
    systemPackages = with pkgs; [
      adwaita-icon-theme
      gnome-themes-extra
    ];
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
    };
  };
}
