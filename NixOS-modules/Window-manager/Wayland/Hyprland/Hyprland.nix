{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = false;
    portalPackage = pkgs.xdg-desktop-portal-hyprland;
    package = pkgs.hyprland;
  };
  programs.uwsm = {
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
}
