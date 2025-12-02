{pkgs, ...}: {
  services = {
    fwupd.enable = true;
    avahi.enable = false;
    printing.enable = false;
    geoclue2.enable = false;
    power-profiles-daemon.enable = true;
  };

  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
    nixos.enable = false;
  };
}
