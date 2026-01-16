{ pkgs, ... }:
{
  services = {
    fwupd.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    avahi.enable = false;
    printing.enable = false;
    geoclue2.enable = false;
    languagetool = {
      enable = true;
      package = pkgs.languagetool;
      settings = {};
      port = 8081;
      jvmOptions = ["-Xmx512m"];
      public = false;
      jrePackage = pkgs.zulu25;
      allowOrigin = null;
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
