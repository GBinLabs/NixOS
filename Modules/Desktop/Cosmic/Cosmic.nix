{pkgs, ...}: {
  services = {
    displayManager = {
      cosmic-greeter = {
        enable = true;
        package = pkgs.cosmic-greeter;
      };
    };
    desktopManager = {
      cosmic = {
        enable = true;
        xwayland = {
          enable = false;
        };
        showExcludedPkgsWarning = true;
      };
    };
  };
}
