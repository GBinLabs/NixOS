{ lib, ... }: {
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 200;
    priority = 10;
  };

  boot.kernel.sysctl = {
    "vm.swappiness" = 100;
    "vm.page-cluster" = 0;
    "vm.vfs_cache_pressure" = 50;
    "vm.compaction_proactiveness" = 0;
    "kernel.sched_cfs_bandwidth_slice_us" = lib.mkForce 500;
  };
}
