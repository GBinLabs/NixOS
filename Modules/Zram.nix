# Modules/Zram.nix
{ config, lib, ... }: {
  options.Zram.enable = lib.mkEnableOption "Zram de alto rendimiento";

  config = lib.mkIf config.Zram.enable {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      swapDevices = 1;
      memoryPercent = 200;
      priority = 100;
    };

    boot.kernel.sysctl = {
      # Configuración óptima para zram
      "vm.swappiness" = 180;
      "vm.page-cluster" = 0;
      "vm.vfs_cache_pressure" = 50;  # Reducido para mejor caché
      "vm.dirty_ratio" = 20;          # Aumentado para mejor escritura
      "vm.dirty_background_ratio" = 10;
      "vm.watermark_scale_factor" = 200;  # Más agresivo
      "vm.min_free_kbytes" = 262144;  # 256MB para 16GB+ RAM
    };
  };
}
