{
  config,
  lib,
  ...
}: {
  options = {
    Zram.enable = lib.mkEnableOption "Habilitar Zram al máximo rendimiento";
  };

  config = lib.mkIf config.Zram.enable {
    # ===== Zram al MÁXIMO para Gaming =====
    zramSwap = {
      enable = true;
      
      # zstd = balance perfecto entre velocidad y compresión (~2.5:1)
      algorithm = "zstd";
      
      # 1 dispositivo zram (óptimo para Ryzen 5 3600)
      swapDevices = 1;
      
      # 200% de RAM (con compresión ~2.5:1 = ~5x RAM efectiva)
      # Con 16GB RAM = 32GB zram → ~80GB efectivos después de compresión
      memoryPercent = 200;
      
      # Todo en RAM, sin writeback a disco
      writebackDevice = null;
      
      # Prioridad máxima (se usa antes que cualquier swap de disco)
      priority = 100;
    };

    # ===== Parámetros del kernel optimizados AL MÁXIMO =====
    boot.kernel.sysctl = {
      # === Swappiness MÁXIMO para zram ===
      # Con zram, swappiness alto NO causa lag - es memoria comprimida en RAM
      # 180 = máxima agresividad, libera RAM física constantemente
      "vm.swappiness" = 180;
      
      # === Page Cluster ===
      # 0 = sin readahead (zram es RAM, no disco - no necesita prefetch)
      "vm.page-cluster" = 0;
      
      # === Compactación de memoria ===
      # 20 = compactación proactiva moderada (ayuda a zstd)
      "vm.compaction_proactiveness" = 20;
      
      # === Watermark (agresividad en recuperación de memoria) ===
      # 125 = agresivo en recuperar memoria para comprimir en zram
      "vm.watermark_scale_factor" = 125;
      
      # Boost temporal para evitar fragmentación
      "vm.watermark_boost_factor" = 15000;
      
      # === Memoria libre mínima ===
      # 128MB mínimo libre antes de activar reclaim
      # Para sistemas con 16GB+ RAM
      "vm.min_free_kbytes" = 131072;  # 128MB
      
      # === Dirty ratios (flush agresivo) ===
      # 10% de RAM antes de flush síncrono
      "vm.dirty_ratio" = 10;
      
      # 5% de RAM para flush asíncrono en background
      "vm.dirty_background_ratio" = 5;
      
      # === VFS Cache Pressure ===
      # 100 = balance normal (zram maneja la presión de memoria)
      "vm.vfs_cache_pressure" = 100;
      
      # === Transparent Huge Pages ===
      # Ya configurado en AMD-CPU.nix como "madvise"
      # Si no tienes AMD-CPU.nix, descomenta:
      # "vm.nr_hugepages" = 0;  # THP dinámicas solamente
    };

    # ===== Parámetros del kernel en boot =====
    boot.kernelParams = [
      # Transparent Huge Pages en modo madvise (óptimo con zram)
      "transparent_hugepage=madvise"
    ];
  };
}
