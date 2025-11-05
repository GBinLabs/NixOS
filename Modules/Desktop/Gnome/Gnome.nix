{pkgs, ...}: {
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
    desktopManager = {
      gnome = {
        enable = true;
      };
    };
    gnome = {
      core-apps = {
        enable = false;
      };
      localsearch = {
        enable = false;
      };
      tinysparql = {
        enable = false;
      };
    };
  };

  hardware = {
    bluetooth = {
      powerOnBoot = false;
    };
  };

  environment = {
    gnome = {
      excludePackages = [pkgs.gnome-tour];
    };
  };
}
