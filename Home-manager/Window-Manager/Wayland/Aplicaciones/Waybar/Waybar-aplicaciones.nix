{pkgs, ...}: {
  home.packages = with pkgs; [
    brightnessctl
    gnome-system-monitor
    btop
    hyprlock
  ];
}
