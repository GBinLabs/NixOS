{pkgs, ...}: {
  services = {
    # Fwupd.
    fwupd = {
      enable = true;
    };
    # End Fwupd.

    # DNS.
    resolved = {
      enable = true;
      extraConfig = ''
        [Resolve]
        DNS=193.110.81.9#zero.dns0.eu
        DNS=2a0f:fc80::9#zero.dns0.eu
        DNS=185.253.5.9#zero.dns0.eu
        DNS=2a0f:fc81::9#zero.dns0.eu
        DNSOverTLS=yes
      '';
    };
    # End DNS.

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
  };

  # Pipewire 2.
  security = {
    rtkit = {
      enable = true;
    };
  };
  # End Pipewire 2.
}
