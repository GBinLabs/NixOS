# Modules/DNS.nix
{config, lib, ...}: {
  options.DNS-Smart.enable = lib.mkEnableOption "DNS inteligente";

  config = lib.mkIf config.DNS-Smart.enable {
    services.resolved = {
      enable = true;
      dnssec = "allow-downgrade";
      domains = ["~."];
      fallbackDns = ["94.140.14.14" "94.140.15.15"];
      dnsovertls = "opportunistic";
      extraConfig = ''
        DNSOverTLS=opportunistic
        DNSSEC=allow-downgrade
        MulticastDNS=no
        LLMNR=no
      '';
    };

    networking.networkmanager.dns = "systemd-resolved";
  };
}
