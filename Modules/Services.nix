_: {
  services = {
    fwupd.enable = true;
    avahi.enable = false;
    printing.enable = false;
    geoclue2.enable = false;
  };

  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
    nixos.enable = false;
  };
}
