{pkgs, ...}: {
  services = {
    # Fwupd.
    fwupd = {
      enable = true;
    };
    # End Fwupd.

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
    
    # USB + Trashcan 1.
    gvfs.enable = true;
    udisks2.enable = true;
    # Final USB + Trashcan 1.
  };

  # USB + Trashcan 2.
  environment.systemPackages = with pkgs; [
    usbutils
    udiskie
    udisks
  ];
  # Final USB + Trashcan 2.
}
