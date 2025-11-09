{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    brightnessctl
    gnome-system-monitor
    btop
    hyprlock
    pwvucontrol
  ];
}
