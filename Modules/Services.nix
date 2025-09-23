{pkgs, ...}: {
  services = {
    # Fwupd.
    fwupd = {
      enable = true;
    };
    # End Fwupd.

    # DNS.
    #resolved = {
    #  enable = true;
    #  extraConfig = ''
    #    [Resolve]
    #    DNS=193.110.81.9#zero.dns0.eu
    #    DNS=2a0f:fc80::9#zero.dns0.eu
    #    DNS=185.253.5.9#zero.dns0.eu
    #    DNS=2a0f:fc81::9#zero.dns0.eu
    #    DNSOverTLS=yes
    #  '';
    #};
    # End DNS.

    # Languagetool.
    languagetool = {
      enable = true;
      package = pkgs.languagetool;
      settings = {};
      port = 8081;
      jvmOptions = ["-Xmx512m"];
      public = false;
      jrePackage = pkgs.jdk;
      allowOrigin = null;
    };
    # End Languagetool.

    # Mouse-DPI.
    ratbagd = {
      enable = true;
      package = pkgs.libratbag;
    };
    # End Mouse-DPI.

    # Pipewire 1.
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse = {
        enable = true;
      };
      jack = {
        enable = true;
      };
      wireplumber = {
        enable = true;
        package = pkgs.wireplumber;
      };
    };
    # End Pipewire 1.
    # USB + Trashcan 1.
    gvfs.enable = true;
    udisks2.enable = true;
    # Final USB + Trashcan 1.
  };

  # Pipewire 2.
  security = {
    rtkit = {
      enable = true;
    };
  };
  # End Pipewire 2.
  
  # USB + Trashcan 2.
  environment.systemPackages = with pkgs; [
    usbutils
    udiskie
    udisks
  ];
  # Final USB + Trashcan 2.
}
