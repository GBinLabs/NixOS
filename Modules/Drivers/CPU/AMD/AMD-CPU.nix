{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    CPU-AMD = {
      enable = lib.mkEnableOption "Habilitar optimizaciones CPU-AMD";

      # Perfil de rendimiento de CPU
      performanceProfile = lib.mkOption {
        type = lib.types.enum ["gaming" "balanced" "powersave"];
        default = "balanced";
        description = ''
          Perfil de rendimiento de CPU:
          - "gaming": Máximo rendimiento constante (performance governor)
          - "balanced": Balance automático (schedutil governor)
          - "powersave": Ahorro de energía (powersave governor)
        '';
      };

      # Habilitar optimizaciones del scheduler
      enableSchedulerTweaks = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Optimizaciones del scheduler de Linux para reducir latencia";
      };

      # Habilitar boost automático
      enableCPUBoost = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Habilitar AMD Precision Boost (hasta 4.2 GHz en Ryzen 5 3600)";
      };
    };
  };

  config = lib.mkIf config.CPU-AMD.enable {
    # ===== Hardware CPU =====
    hardware = {
      cpu = {
        amd = {
          # Actualizar microcódigo automáticamente
          updateMicrocode = true;
        };
      };
    };

    # ===== Módulos del kernel =====
    boot = {
      # Módulos necesarios para control de CPU AMD
      kernelModules = [
        "kvm-amd" # Virtualización (útil para gaming con anti-cheat)
        "msr" # Model-Specific Registers (para monitoreo)
      ];

      # Parámetros del kernel optimizados para Ryzen 5 3600 (Zen 2)
      kernelParams = [
        # === CPU Performance ===
        # Deshabilitar mitigaciones de Spectre/Meltdown para +5-10% FPS
        # ⚠️ Solo si no manejas datos sensibles
        "mitigations=off"

        # Zen 2 soporta IOMMU bien
        "amd_iommu=on"
        "iommu=pt" # Passthrough mode (mejor para gaming/VM)

        # === Optimizaciones de memoria ===
        "transparent_hugepage=madvise" # Huge pages bajo demanda

        # === Scheduler optimizations ===
        "preempt=full" # Mejor latencia para gaming (kernel 6.6+)

        # === Tick rate ===
        # Si compilas kernel custom, usa CONFIG_HZ=1000
        # Por defecto NixOS usa 250, que está bien
      ];
    };

    # ===== CPU Governor y Power Management =====
    powerManagement = {
      # Habilitar power management de CPU
      enable = true;

      # Governor según perfil
      cpuFreqGovernor = lib.mkMerge [
        (lib.mkIf (config.CPU-AMD.performanceProfile == "gaming") "performance")
        (lib.mkIf (config.CPU-AMD.performanceProfile == "balanced") "schedutil")
        (lib.mkIf (config.CPU-AMD.performanceProfile == "powersave") "powersave")
      ];
    };

    # ===== Configuración de sysctl (kernel runtime) =====
    boot.kernel.sysctl = lib.mkMerge [
      # === Configuración base ===
      {
        # Mejorar scheduling para gaming
        "kernel.sched_migration_cost_ns" = 5000000; # 5ms - reduce migraciones de core
        "kernel.sched_min_granularity_ns" = 10000000; # 10ms - mejor para gaming
        "kernel.sched_wakeup_granularity_ns" = 15000000; # 15ms

        # Scheduler latency
        "kernel.sched_latency_ns" = 20000000; # 20ms - bueno para gaming

        # === VM (memoria virtual) optimizations ===
        # NOTA: swappiness NO se configura aquí porque usas Zram.nix
        # Tu Zram.nix ya lo configura en 180 (óptimo para zram)

        # Optimizaciones específicas para Zram
        #"vm.page-cluster" = 0; # Deshabilitar readahead en swap (zram es rápido)
        #"vm.vfs_cache_pressure" = 100; # Balance normal (zram maneja la presión)
        #"vm.dirty_ratio" = 10; # Porcentaje de RAM antes de flush
        #"vm.dirty_background_ratio" = 5; # Background flush

        ## Compaction y THP (útil con Zram)
        #"vm.compaction_proactiveness" = 20; # Compactación proactiva moderada
        #"vm.watermark_scale_factor" = 125; # Más agresivo con recuperación de memoria

        # Network optimizations (útil para gaming online)
        "net.core.netdev_max_backlog" = 16384;
        "net.ipv4.tcp_fastopen" = 3;
        "net.ipv4.tcp_mtu_probing" = 1;
      }

      # === Optimizaciones adicionales para gaming profile ===
      (lib.mkIf (config.CPU-AMD.performanceProfile == "gaming") {
        # Priorizar throughput sobre latencia en algunas operaciones
        "kernel.sched_autogroup_enabled" = 0; # Deshabilitar autogroup

        # Con Zram: NO reducimos swappiness porque zram es memoria comprimida en RAM
        # El swappiness alto (180) es correcto para zram
        # Por eso este perfil NO sobrescribe vm.swappiness
      })
    ];

    # ===== CPU Boost y performance tweaks via systemd =====
    systemd.tmpfiles.rules = lib.mkMerge [
      # Habilitar/deshabilitar CPU boost
      (lib.mkIf config.CPU-AMD.enableCPUBoost [
        "w /sys/devices/system/cpu/cpufreq/boost - - - - 1"
      ])

      (lib.mkIf (!config.CPU-AMD.enableCPUBoost) [
        "w /sys/devices/system/cpu/cpufreq/boost - - - - 0"
      ])

      # Optimizaciones de scheduler por perfil
      (lib.mkIf (config.CPU-AMD.performanceProfile == "gaming") [
        # Deshabilitar CPU idle states profundos para mínima latencia
        # ⚠️ Aumenta consumo, pero elimina stuttering
        "w /sys/devices/system/cpu/cpu*/cpuidle/state3/disable - - - - 1"
      ])
    ];

    # ===== Servicios y optimizaciones adicionales =====
    services = {
      # Irqbalance - distribuir interrupciones entre cores
      irqbalance = {
        enable = true;
      };
    };

    # ===== Paquetes útiles para monitoreo =====
    environment.systemPackages = with pkgs; [
      # Info de CPU
      lm_sensors # Temperaturas (ejecuta 'sensors' después de 'sensors-detect')
      cpufrequtils # Info de frecuencias (cpufreq-info)
    ];

    # ===== Variables de entorno =====
    environment.sessionVariables = {
      # Optimizaciones de CPU para aplicaciones
      # Usar todas las threads disponibles (Ryzen 5 3600 = 6 cores, 12 threads)
      OMP_NUM_THREADS = "12";

      # Afinidad de CPU para mejor caché locality
      OMP_PROC_BIND = "true";
    };

    # ===== Optimizaciones del scheduler (si están habilitadas) =====
    boot.kernelPatches = lib.mkIf config.CPU-AMD.enableSchedulerTweaks [];
    # Nota: Las optimizaciones de scheduler se aplican vía sysctl arriba
    # Si quieres un kernel custom (cachyos, zen, etc), configúralo aquí

    # ===== Configuración de procesos en tiempo real (para audio/gaming) =====
    security.pam.loginLimits = [
      {
        domain = "@users";
        type = "soft";
        item = "rtprio";
        value = "99";
      }
      {
        domain = "@users";
        type = "hard";
        item = "rtprio";
        value = "99";
      }
      {
        domain = "@users";
        type = "soft";
        item = "memlock";
        value = "unlimited";
      }
      {
        domain = "@users";
        type = "hard";
        item = "memlock";
        value = "unlimited";
      }
    ];
  };
}
