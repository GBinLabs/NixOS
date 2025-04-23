{
  config,
  lib,
  ...
}: {
  options = {
    Monitor-PC.enable = lib.mkEnableOption "Habilitar Monitor-PC";
  };

  config = lib.mkIf config.Monitor-PC.enable {
    wayland.windowManager.hyprland = {
      settings = {
        monitor = "HDMI-A-1,1920x1080@60,0x0,1";
      };
    };
  };
}
