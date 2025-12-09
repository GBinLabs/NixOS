{pkgs, ...}: {
  services = {
    fwupd.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    avahi.enable = false;
    printing.enable = false;
    geoclue2.enable = false;
    ratbagd = {
      enable = true;
      package = pkgs.libratbag;
    };
  };

  environment.systemPackages = with pkgs; [usbutils];

  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
    nixos.enable = false;
  };
}
