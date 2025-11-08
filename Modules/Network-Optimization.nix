# Modules/Network-Optimization.nix
{...}: {
  boot.kernel.sysctl = {
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_fastopen" = 3;
    "net.ipv4.tcp_low_latency" = 1;
    "net.ipv4.tcp_timestamps" = 0;
    "net.core.netdev_max_backlog" = 16384;
    "net.ipv4.tcp_rmem" = "4096 87380 134217728";
    "net.ipv4.tcp_wmem" = "4096 65536 134217728";
  };
  
  networking.networkmanager.wifi = {
    backend = "iwd";
    powersave = false;
  };
}
