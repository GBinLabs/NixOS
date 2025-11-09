{pkgs, ...}: let
  customized_sddm_astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "black_hole";
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

  ## Fonts.
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };

  environment.systemPackages = [
    customized_sddm_astronaut
  ];
}
