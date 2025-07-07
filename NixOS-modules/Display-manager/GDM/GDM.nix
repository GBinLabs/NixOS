_: {
  services = {
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
        banner = ''¡Hola!'';
        autoSuspend = true;
        debug = false;
      };
      defaultSession = "gnome";
    };
  };
}
