{
  config,
  lib,
  ...
}: {
  options = {
    Monitor-Notebook.enable = lib.mkEnableOption "Habilitar Monitor-Notebook";
  };

  config = lib.mkIf config.Monitor-Notebook.enable {
    wayland.windowManager.hyprland = {
      settings = {
        monitor = "eDP1,1366x768@60,0x0,1";
      };
    };
  };
}
