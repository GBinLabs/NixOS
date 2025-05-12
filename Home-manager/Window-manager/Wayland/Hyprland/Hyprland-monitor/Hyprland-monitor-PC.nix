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
        monitor = "HDMI-A-1,1920x1080@75,0x0,1";
      };
    };
  };
}
