# Modules/Network-Optimization.nix
{ ... }: {
  # === NETWORK GAMING OPTIMIZATIONS ===
  boot.kernel.sysctl = {
    # === TCP OPTIMIZATIONS ===
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_notsent_lowat" = 16384;
    "net.ipv4.tcp_low_latency" = 1;
    "net.ipv4.tcp_slow_start_after_idle" = 0;
    
    # Fast Open
    "net.ipv4.tcp_fastopen" = 3;
    
    # Timestamps OFF (menos overhead)
    "net.ipv4.tcp_timestamps" = 0;
    
    # Window scaling
    "net.ipv4.tcp_window_scaling" = 1;
    
    # MTU probing
    "net.ipv4.tcp_mtu_probing" = 1;
    
    # Reuse sockets
    "net.ipv4.tcp_tw_reuse" = 1;
    
    # SYN cookies (protección DDoS)
    "net.ipv4.tcp_syncookies" = 1;
    
    # === BUFFERS (gaming optimizado) ===
    "net.core.rmem_default" = 16777216;
    "net.core.rmem_max" = 134217728;
    "net.core.wmem_default" = 16777216;
    "net.core.wmem_max" = 134217728;
    "net.core.netdev_max_backlog" = 16384;
    "net.core.somaxconn" = 8192;
    
    # TCP buffers
    "net.ipv4.tcp_rmem" = "4096 87380 134217728";
    "net.ipv4.tcp_wmem" = "4096 65536 134217728";
    "net.ipv4.tcp_mem" = "134217728 134217728 134217728";
    
    # === UDP (importante para juegos) ===
    "net.ipv4.udp_rmem_min" = 16384;
    "net.ipv4.udp_wmem_min" = 16384;
    
    # === QDISC ===
    "net.core.default_qdisc" = "fq";
    
    # === IPv6 (deshabilitar si no usas) ===
    # "net.ipv6.conf.all.disable_ipv6" = 1;
    # "net.ipv6.conf.default.disable_ipv6" = 1;
    
    # === ROUTING ===
    "net.ipv4.ip_forward" = 0;
    "net.ipv4.conf.all.rp_filter" = 1;
    "net.ipv4.conf.default.rp_filter" = 1;
  };
  
  # NetworkManager optimizations
  networking.networkmanager = {
    wifi = {
      backend = "iwd";  # Más rápido que wpa_supplicant
      powersave = false;  # Performance mode
    };
    
    # DNS rápido
    dns = "systemd-resolved";
  };
}
