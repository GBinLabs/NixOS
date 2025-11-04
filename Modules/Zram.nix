# Modules/Zram.nix
{
  config,
  lib,
  ...
}: {
  options.Zram.enable = lib.mkEnableOption "Zram gaming";

  config = lib.mkIf config.Zram.enable {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      swapDevices = 1;
      memoryPercent = 200;
      priority = 100;
    };

    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.page-cluster" = 0;
      "vm.vfs_cache_pressure" = 50;
      "vm.compaction_proactiveness" = 20;
      "vm.watermark_scale_factor" = 200;
      "vm.min_free_kbytes" = 262144;
      "vm.oom_kill_allocating_task" = 1;
      "vm.panic_on_oom" = 0;
      "vm.nr_hugepages" = 1024;
    };
  };
}
