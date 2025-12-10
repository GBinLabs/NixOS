{pkgs, ...}: {
  services = {
    fwupd.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    avahi.enable = false;
    printing.enable = false;
    geoclue2.enable = false;
    scx = {
      enable = true;
      package = pkgs.scx.rustscheds;
      scheduler = "scx_cosmos";
      extraArgs = ["-m" "powersave" "-d" "-p" "5000"];
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
