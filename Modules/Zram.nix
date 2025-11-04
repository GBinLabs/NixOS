# Modules/Zram.nix
# Zram de ALTO RENDIMIENTO para gaming
# Mismo config para PC y Netbook - sin diferenciación
{
  config,
  lib,
  ...
}: {
  options.Zram.enable = lib.mkEnableOption "Zram de alto rendimiento para gaming";

  config = lib.mkIf config.Zram.enable {
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      swapDevices = 1;

      # 200% para AMBAS máquinas (gaming focus)
      # PC: 16GB RAM → 32GB zram
      # Netbook: 8GB RAM → 16GB zram
      memoryPercent = 200;

      priority = 100;
    };

    boot.kernel.sysctl = {
      # Configuración AGRESIVA para gaming
      # Funciona perfecto para ambas máquinas

      # Swappiness ALTO (zram es rápido)
      "vm.swappiness" = 180;

      # Desactivar readahead (zram no lo necesita)
      "vm.page-cluster" = 0;

      # Caché pressure balanceado
      "vm.vfs_cache_pressure" = 50;

      # Dirty ratios para gaming (escritura agresiva)
      "vm.dirty_ratio" = 20;
      "vm.dirty_background_ratio" = 10;
      #"vm.dirty_writeback_centisecs" = 1500;
      "vm.dirty_expire_centisecs" = 3000;

      # Compaction agresiva (mejor para gaming)
      "vm.compaction_proactiveness" = 20;
      "vm.watermark_scale_factor" = 200;

      # Min free KB según RAM disponible (automático)
      # PC: 262144 (256MB), Netbook: 131072 (128MB)
      "vm.min_free_kbytes" = 262144;

      # OOM killer agresivo
      "vm.oom_kill_allocating_task" = 1;
      "vm.panic_on_oom" = 0;

      # Transparent Hugepages (gaming performance)
      "vm.nr_hugepages" = 512; # 1GB de hugepages
    };
  };
}
