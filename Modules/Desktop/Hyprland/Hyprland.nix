{pkgs, ...}: let
  customized_sddm_astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "hyprland_kath";
  };
in {
  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland = {
        enable = true;
      };
      portalPackage = pkgs.xdg-desktop-portal-hyprland;
      package = pkgs.hyprland;
    };
    uwsm = {
      enable = true;
      package = pkgs.uwsm;
      waylandCompositors = {
        hyprland = {
          prettyName = "Hyprland";
          #comment = "Hyprland compositor manager by UWSM";
          binPath = "/run/current-system/sw/bin/Hyprland";
        };
      };
    };
  };

  services = {
    displayManager = {
      sddm = {
        enable = true;
        wayland = {
          enable = true;
        };
        theme = "sddm-astronaut-theme";
        settings = {
          Theme = {
            Current = "sddm-astronaut-theme";
          };
        };
        package = pkgs.kdePackages.sddm;
        extraPackages = with pkgs; [
          customized_sddm_astronaut
          kdePackages.qtmultimedia
        ];
      };
      defaultSession = "hyprland-uwsm";
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
      stix-two
      stix-otf
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

  environment = {
    systemPackages = [
      customized_sddm_astronaut
    ];
    shells = with pkgs; [zsh];
  };

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "kitty.desktop"
      ];
    };
  };
}
