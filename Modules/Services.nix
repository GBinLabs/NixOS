{ pkgs, ... }:
{
  services = {
    fwupd.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    avahi.enable = false;
    printing.enable = false;
    geoclue2.enable = false;
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
      rulesProvider = pkgs.ananicy-cpp;
      extraRules = [
        {
          "name" = "gamescope";
          "nice" = -20;
        }
      ];
    };
    scx = {
      enable = true;
      package = pkgs.scx.rustscheds;
      scheduler = "scx_lavd";
      extraArgs = [ "--performance" ];
    };
    ratbagd = {
      enable = true;
      package = pkgs.libratbag;
    };
    tuned = {
      enable = true;
    };
    upower = {
      enable = true;
    };
  };
  
  environment.systemPackages = with pkgs; [ usbutils ];

  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
    nixos.enable = false;
  };
}
