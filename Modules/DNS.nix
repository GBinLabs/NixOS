{
  config,
  lib,
  ...
}:
{
  services.resolved = {
    enable = true;
    dnssec = "true";
    domains = [ "~." ];
    dnsovertls = "true";
    extraConfig = ''
      DNS=9.9.9.9#dns.quad9.net
      DNS=149.112.112.112#dns.quad9.net
      DNS=2620:fe::fe#dns.quad9.net
      DNS=2620:fe::9#dns.quad9.net
      MulticastDNS=no
      LLMNR=no
      Cache=yes
      DNSStubListener=yes
      CacheFromLocalhost=no
    '';
  };

  networking.networkmanager = {
    dns = "systemd-resolved";
    wifi = {
      powersave = false;
    };
  };
}
