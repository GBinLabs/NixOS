{pkgs, ...}: {
  services = {
    fwupd.enable = true;
    avahi.enable = false;
    printing.enable = false;
    geoclue2.enable = false;
    scx = {
      enable = true;
      package = pkgs.scx.rustscheds;
      scheduler = "scx_lavd";
      extraArgs = ["--performance"];
    };
    ratbagd = {
    	enable = true;
    	package = pkgs.libratbag;
    };
  };

  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
    nixos.enable = false;
  };
}
