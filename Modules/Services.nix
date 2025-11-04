# Modules/Services.nix
{pkgs, ...}: {
  services = {
    # === ESENCIALES ===
    fwupd.enable = true;

    languagetool = {
      enable = true;
      package = pkgs.languagetool;
      port = 8081;
      jvmOptions = ["-Xmx512m"];
      public = false;
      jrePackage = pkgs.jdk;
    };

    ratbagd = {
      enable = true;
      package = pkgs.libratbag;
    };

    gvfs.enable = true;
    udisks2.enable = true;

    # === DESHABILITAR INNECESARIOS ===
    # Avahi (mDNS/DNS-SD) - solo si usas impresoras en red
    avahi = {
      enable = false;
      nssmdns4 = false;
    };

    # CUPS (impresoras) - solo si lo necesitas
    printing.enable = false;

    # Geoclue (ubicación) - innecesario
    geoclue2.enable = false;

    # ModemManager - solo si usas módem 3G/4G
    #modemmanager.enable = false;

    # Thermald - solo Intel, y solo si tienes problemas térmicos
    thermald.enable = false;

    # TLP ya fue eliminado en Intel-CPU.nix
  };

  # === USB + Papelera ===
  environment.systemPackages = with pkgs; [
    usbutils
    udiskie
    udisks
  ];

  # === DESHABILITAR DOCUMENTACIÓN (ahorra espacio + tiempo rebuild) ===
  documentation = {
    enable = true;
    doc.enable = false;
    man.enable = true;
    dev.enable = false;
    nixos.enable = false;
  };
}
