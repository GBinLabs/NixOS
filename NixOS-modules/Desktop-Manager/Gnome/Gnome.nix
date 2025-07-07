{pkgs, ...}: {
  services = {
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
