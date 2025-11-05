{pkgs, ...}: {
  services = {
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-connections
    epiphany
    geary
    gnome-maps
    gnome-music
    gnome-weather
    gnome-contacts
    gnome-clocks
    simple-scan
    totem
    yelp
  ];
}
