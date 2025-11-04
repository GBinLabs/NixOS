# Modules/Gaming/Gaming-Optimization.nix
# Optimizaciones GENERALES para gaming
# NO específicas de ningún juego en particular
# Funciona para: Steam games, Lutris, Wine, Proton, nativos, etc.
{
  config,
  pkgs,
  lib,
  ...
}: {
  options.Gaming-Optimization.enable = lib.mkEnableOption "Optimizaciones generales para gaming";

  config = lib.mkIf config.Gaming-Optimization.enable {
    # ===== KERNEL PARAMETERS =====
    boot.kernelParams = [
      # Threading
      "threadirqs" # IRQs con threads (menos latencia)

      # Tickless kernel (menos interrupciones = mejor performance)
      "nohz=on"
      "nohz_full=1-11" # Ajusta según tus cores
      # PC Ryzen 5 3600: 1-11 (12 threads)
      # Netbook N4020: 1 (2 threads) - se ajusta automático

      # Desactivar mitigaciones (SOLO para gaming, +10% FPS)
      "mitigations=off"

      # Evitar warnings que causan stuttering
      "split_lock_detect=off"

      # Transparent Hugepages
      "transparent_hugepage=madvise"
      "hugepagesz=2M"
      "default_hugepagesz=2M"
      "hugepages=512" # 1GB hugepages

      # Memory management
      "vm.max_map_count=2147483642" # Para juegos que usan mucha memoria mapeada
    ];

    # ===== SYSCTL OPTIMIZATIONS =====
    boot.kernel.sysctl = {
      # === RED (crucial para online gaming) ===
      "net.ipv4.tcp_congestion_control" = "bbr"; # BBR mejor que cubic
      "net.ipv4.tcp_low_latency" = 1;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_mtu_probing" = 1;
      "net.ipv4.tcp_timestamps" = 0; # Menos overhead
      "net.ipv4.tcp_tw_reuse" = 1;
      "net.ipv4.tcp_window_scaling" = 1;
      "net.ipv4.tcp_sack" = 1;

      # Buffer sizes (gaming optimizado)
      "net.core.netdev_max_backlog" = 16384;
      "net.core.rmem_max" = 134217728; # 128MB
      "net.core.wmem_max" = 134217728;
      "net.core.rmem_default" = 16777216; # 16MB
      "net.core.wmem_default" = 16777216;
      "net.ipv4.tcp_rmem" = "4096 87380 134217728";
      "net.ipv4.tcp_wmem" = "4096 65536 134217728";

      # Reduce buffer bloat
      "net.core.default_qdisc" = "fq";

      # === SCHEDULER (gaming focus) ===
      "kernel.sched_min_granularity_ns" = 2000000; # 2ms
      #"kernel.sched_wakeup_granularity_ns" = 3000000; # 3ms
      #"kernel.sched_migration_cost_ns" = 500000; # 0.5ms
      "kernel.sched_latency_ns" = 20000000; # 20ms
      "kernel.sched_autogroup_enabled" = 0; # Mejor para gaming

      # === FILESYSTEM (reduce I/O delays) ===
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;
      "vm.dirty_writeback_centisecs" = 1500;
      "vm.dirty_expire_centisecs" = 3000;

      # === FILE HANDLES ===
      #"fs.file-max" = 2097152;
      #"fs.inotify.max_user_watches" = 524288;
    };

    # ===== HUGEPAGES =====
    boot.kernelModules = ["hugepages"];

    systemd.tmpfiles.rules = [
      "w /sys/kernel/mm/transparent_hugepage/enabled - - - - madvise"
      "w /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"
      "w /sys/kernel/mm/transparent_hugepage/khugepaged/defrag - - - - 0"
    ];

    # ===== VARIABLES DE ENTORNO (GAMING GENERAL) =====
    environment.sessionVariables = {
      # Mesa/OpenGL optimizations
      "MESA_GLTHREAD" = "true";
      "MESA_NO_ERROR" = "1";
      "MESA_LOADER_DRIVER_OVERRIDE" = "radeonsi";

      # Shader cache grande
      "MESA_DISK_CACHE_SIZE" = "8192M"; # 8GB
      "MESA_DISK_CACHE_SINGLE_FILE" = "true";
      "MESA_DISK_CACHE_DATABASE" = "true";

      # AMD Vulkan
      "AMD_VULKAN_ICD" = "RADV";
      "RADV_PERFTEST" = "nggc,sam,rt,nir";
      "RADV_DEBUG" = "zerovram";

      # VSync off (control por juego)
      "vblank_mode" = "0";
      "__GL_SYNC_TO_VBLANK" = "0";

      # Proton/Wine
      "PROTON_NO_ESYNC" = "0";
      "PROTON_NO_FSYNC" = "0";
      # NO incluir DXVK_ASYNC por defecto (puede causar bans)

      # Threading
      "OMP_NUM_THREADS" = "12"; # Ajusta según CPU
      "OMP_PROC_BIND" = "true";

      # SDL
      "SDL_THREAD_PRIORITY_POLICY" = "2";
      "SDL_VIDEODRIVER" = "wayland";
    };

    # ===== I/O SCHEDULER =====
    services.udev.extraRules = ''
      # Scheduler según tipo de disco
      ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/scheduler}="none"
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"

      # Desactivar autosuspend USB (dispositivos de entrada)
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/autosuspend", ATTR{power/autosuspend}="-1"

      # Network latency
      ACTION=="add", SUBSYSTEM=="net", RUN+="${pkgs.ethtool}/bin/ethtool -s $name wol d"
    '';

    # ===== SYSTEMD SLICES =====
    systemd.slices = {
      "gaming" = {
        description = "Gaming workload slice";
        sliceConfig = {
          CPUWeight = 1000;
          IOWeight = 1000;
          MemoryHigh = "80%";
          MemoryMax = "95%";
        };
      };

      "background" = {
        description = "Background workload slice";
        sliceConfig = {
          CPUWeight = 50;
          IOWeight = 50;
          MemoryHigh = "50%";
        };
      };
    };

    # ===== GAMEMODE (mejorado) =====
    programs.gamemode.settings = {
      general = {
        softrealtime = "auto";
        renice = -20; # Máxima prioridad
        ioprio = 0;
      };

      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
        amd_performance_level = "high";
      };

      cpu = {
        park_cores = "no";
        pin_cores = "yes";
      };

      custom = {
        start = "${pkgs.writeShellScript "gamemode-start" ''
          sync
          echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null
          ${pkgs.libnotify}/bin/notify-send -u low "GameMode" "Optimizaciones de gaming activas" -t 2000
        ''}";

        end = "${pkgs.writeShellScript "gamemode-end" ''
          ${pkgs.libnotify}/bin/notify-send -u low "GameMode" "Modo normal restaurado" -t 2000
        ''}";
      };
    };

    # ===== PERMISOS REALTIME =====
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
        item = "nice";
        value = "-20";
      }
      {
        domain = "@users";
        type = "hard";
        item = "nice";
        value = "-20";
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

    # Sudo sin contraseña para comandos de gaming
    security.sudo.extraRules = [
      {
        users = ["german"];
        commands = [
          {
            command = "/run/current-system/sw/bin/tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor";
            options = ["NOPASSWD"];
          }
          {
            command = "/run/current-system/sw/bin/tee /sys/class/drm/card*/device/power_dpm_force_performance_level";
            options = ["NOPASSWD"];
          }
          {
            command = "/run/current-system/sw/bin/tee /proc/sys/vm/drop_caches";
            options = ["NOPASSWD"];
          }
        ];
      }
    ];

    # ===== SCRIPTS ÚTILES =====
    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "gaming-mode-on" ''
        #!/usr/bin/env bash
        echo "🎮 Activando modo gaming..."

        # CPU a performance
        for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
          echo "performance" | sudo tee "$cpu" > /dev/null 2>&1 || true
        done

        # GPU a high
        for card in /sys/class/drm/card*/device/power_dpm_force_performance_level; do
          echo "high" | sudo tee "$card" > /dev/null 2>&1 || true
        done

        # Limpiar caché
        sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null

        notify-send "Gaming Mode" "Sistema optimizado" -u low -t 2000
        echo "✅ Modo gaming activado"
      '')

      (writeShellScriptBin "gaming-mode-off" ''
        #!/usr/bin/env bash
        echo "🔄 Restaurando modo normal..."

        # CPU a schedutil
        for cpu in /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor; do
          echo "schedutil" | sudo tee "$cpu" > /dev/null 2>&1 || true
        done

        # GPU a auto
        for card in /sys/class/drm/card*/device/power_dpm_force_performance_level; do
          echo "auto" | sudo tee "$card" > /dev/null 2>&1 || true
        done

        notify-send "Gaming Mode" "Modo normal restaurado" -u low -t 2000
        echo "✅ Modo normal"
      '')

      schedtool # Para CPU affinity si lo necesitas manualmente
    ];
  };
}
