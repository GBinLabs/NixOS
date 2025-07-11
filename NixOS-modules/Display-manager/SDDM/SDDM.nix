{pkgs, ...}: {
  # SDDM
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      package = pkgs.kdePackages.sddm;
      extraPackages = with pkgs; [
        kdePackages.qtmultimedia
        kdePackages.qtsvg
        kdePackages.qtvirtualkeyboard
      ];
    };
    defaultSession = "hyprland-uwsm";
  };
  # Final SDDM

  environment.systemPackages = [
    (pkgs.callPackage ./sddm-astronaut-theme.nix {
      theme = "pixel_sakura";
      themeConfig = {
        General = {
          HeaderText = "¡Hola!";
          FontSize = "10.0";
          ForceHideCompletePassword = true;
        };
      };
    })
  ];
}
