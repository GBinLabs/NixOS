{pkgs, ...}:

let
  customized_sddm_astronaut = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura"; # The name of the theme you most loved
  };
in
{
  # Window-Manager Hyprland + SDDM.

  ## Hyprland.
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
  ## Final Hyprland.

  ## SDDM.
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
  ## Final SDDM.

  ## Fonts.
  fonts = {
    packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };
  
  environment.systemPackages = with pkgs; [
  	customized_sddm_astronaut
  ];
}
