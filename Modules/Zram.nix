# Modules/Zram.nix
{config, lib, ...}: {
  options.Zram.enable = lib.mkEnableOption "Zram optimizado";

  config = lib.mkIf config.Zram.enable {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 100;
      priority = 10;
    };

    boot.kernel.sysctl = {
      "vm.swappiness" = 180;
      "vm.page-cluster" = 0;
      "vm.vfs_cache_pressure" = 50;
    };
  };
}
