{pkgs, ...}: {
  services = {
    displayManager = {
      cosmic-greeter = {
        enable = true;
        package = pkgs.cosmic-greeter;
      };
      defaultSession = "cosmic";
    };
    desktopManager = {
      cosmic = {
        enable = true;
        xwayland = {
          enable = false;  # Mantén en false para máxima ligereza
        };
        showExcludedPkgsWarning = false;
      };
    };
  };

  # Configuración de fuentes similar a Gnome
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

  # Bluetooth configurado igual que en Gnome
  hardware.bluetooth.powerOnBoot = false;
}