{pkgs, ...}: {
  services = {
    fwupd.enable = true;
    avahi.enable = false;
    printing.enable = false;
    geoclue2.enable = false;
    power-profiles-daemon.enable = true;
    languagetool = {
      enable = true;
      package = pkgs.eloquent;
      port = 8081;
      jvmOptions = ["-Xmx512m"];
      public = false;
      jrePackage = pkgs.zulu25;
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
