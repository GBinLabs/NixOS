_: {
  services = {
    resolved = {
      enable = true;
      extraConfig = ''
        [Resolve]
        DNS=193.110.81.0#dns0.eu
        DNS=2a0f:fc80::#dns0.eu
        DNS=185.253.5.0#dns0.eu
        DNS=2a0f:fc81::#dns0.eu
        DNSOverTLS=yes
      '';
    };
  };
}
