# Home-manager/Window-Manager/Wayland/Hyprland/Hyprland/Variables/Monitor.nix
{
  config,
  lib,
  ...
}: {
  options.Monitor-PC.enable = lib.mkEnableOption "Monitor PC (HDMI 1080p@90Hz)";
  options.Monitor-Notebook.enable = lib.mkEnableOption "Monitor Notebook (eDP 768p@60Hz)";
  options.Monitor-Netbook.enable = lib.mkEnableOption "Monitor Netbook (eDP 768p@60Hz)";

  config = lib.mkMerge [
    (lib.mkIf config.Monitor-PC.enable {
      wayland.windowManager.hyprland.settings.monitor = [
        "HDMI-A-1,1920x1080@75,0x0,1"
        ",preferred,auto,1" # Fallback para otros monitores
      ];
    })

    (lib.mkIf config.Monitor-Notebook.enable {
      wayland.windowManager.hyprland.settings.monitor = [
        "eDP-1,1366x768@60,0x0,1"
        ",preferred,auto,1"
      ];
    })

    (lib.mkIf config.Monitor-Netbook.enable {
      wayland.windowManager.hyprland.settings.monitor = [
        "eDP-1,1366x768@60,0x0,1"
        ",preferred,auto,1"
      ];
    })
  ];
}
