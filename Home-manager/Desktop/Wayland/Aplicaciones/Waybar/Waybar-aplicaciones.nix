{ pkgs, ... }:
{
  home.packages = with pkgs; [
    brightnessctl
    btop
    hyprlock
    pwvucontrol
  ];
}
