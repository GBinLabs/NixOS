{config, lib, ...}: {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 200;
      priority = 10;
    };

    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.page-cluster" = 0;
      "vm.vfs_cache_pressure" = 50;
    };
}
