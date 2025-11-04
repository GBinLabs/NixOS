# Modules/Boot.nix
{ pkgs, ... }: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 10;  # Limitar generaciones
        consoleMode = "auto";
      };
      efi.canTouchEfiVariables = true;
      timeout = 1;  # Boot rápido
    };
    
    # Kernel Zen (óptimo para gaming)
    kernelPackages = pkgs.linuxPackages_zen;
    
    # Parámetros globales de rendimiento
    kernelParams = [
      # === Performance ===
      "mitigations=off"          # +5-10% FPS (SEGURO en PC gaming)
      "nowatchdog"               # Reduce overhead
      "nmi_watchdog=0"
      
      # === Scheduler ===
      "preempt=full"             # Kernel 6.6+ baja latencia
      
      # === Transparent Huge Pages ===
      "transparent_hugepage=madvise"
      
      # === Memory ===
      "hugepagesz=2M"
      "default_hugepagesz=2M"
    ];
    
    # Módulos en initrd para boot rápido
    initrd = {
      availableKernelModules = [ 
        "nvme" 
        "xhci_pci" 
        "ahci" 
        "usbhid" 
        "sd_mod"
      ];
      
      # Compresión más rápida
      compressor = "zstd";
      compressorArgs = [ "-19" "-T0" ];  # Máxima compresión multithread
    };
    
    # Optimizaciones del kernel
    kernel.sysctl = {
      # Network performance (importante para online gaming)
      "net.core.netdev_max_backlog" = 16384;
      "net.core.rmem_default" = 1048576;
      "net.core.rmem_max" = 16777216;
      "net.core.wmem_default" = 1048576;
      "net.core.wmem_max" = 16777216;
      "net.ipv4.tcp_rmem" = "4096 1048576 2097152";
      "net.ipv4.tcp_wmem" = "4096 65536 16777216";
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_mtu_probing" = 1;
      
      # File system
      "fs.file-max" = 2097152;
      "fs.inotify.max_user_watches" = 524288;
    };
    
    # Plymouth para boot bonito (opcional)
    plymouth = {
      enable = true;
      theme = "breeze";
    };
  };
}
