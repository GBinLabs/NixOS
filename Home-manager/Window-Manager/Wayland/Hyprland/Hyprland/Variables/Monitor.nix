# Home-manager/Window-Manager/Wayland/Hyprland/Variables/Monitor.nix
{
  config,
  lib,
  ...
}: let
  # Mapeo de hostname a configuración de monitor
  monitorConfigs = {
    "Bin-PC" = "HDMI-A-1,1920x1080@75,0x0,1";
    "Bin-Notebook" = "eDP-1,1366x768@60,0x0,1";
    "Bin-Netbook" = "eDP-1,1366x768@60,0x0,1";
  };

  hostname = config.networking.hostName or "unknown";
  monitorConfig = monitorConfigs.${hostname} or "eDP-1,preferred,auto,1";
in {
  wayland.windowManager.hyprland.settings = {
    monitor = [monitorConfig];
  };
}
