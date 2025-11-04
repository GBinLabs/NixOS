{...}: {
  networking = {
    # Deshabilitar DNS automático de DHCP
    dhcpcd.extraConfig = "nohook resolv.conf";

    # Configurar nameservers de AdGuard Family Protection (más estricto)
    nameservers = [
      "94.140.14.14" # AdGuard Family Protection Primary
      "94.140.15.15" # AdGuard Family Protection Secondary
    ];

    # Alternativa con DNS-over-TLS (más seguro)
    networkmanager.dns = "systemd-resolved";
  };

  # Configurar systemd-resolved para DNS-over-TLS
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = ["~."];
    fallbackDns = ["94.140.14.14" "94.140.15.15"];
    dnsovertls = "true";
    extraConfig = ''
      DNS=94.140.14.14#dns.adguard.com 94.140.15.15#dns.adguard.com
      DNSOverTLS=yes
      DNSSEC=yes
      MulticastDNS=no
    '';
  };
}
