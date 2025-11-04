# Modules/Gaming-Optimization.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  options.Gaming-Optimization.enable = lib.mkEnableOption "Optimizaciones generales para gaming";

  config = lib.mkIf config.Gaming-Optimization.enable {
    boot.kernelParams = [
      "threadirqs"
      "nohz=on"
      "mitigations=off"
      "split_lock_detect=off"
      "transparent_hugepage=always"
      "hugepagesz=2M"
      "default_hugepagesz=2M"
      "hugepages=1024"
      "vm.max_map_count=2147483642"
    ];

    boot.kernel.sysctl = {
      # === NETWORK ===
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.ipv4.tcp_low_latency" = 1;
      "net.ipv4.tcp_fastopen" = 3;
      "net.ipv4.tcp_mtu_probing" = 1;
      "net.ipv4.tcp_timestamps" = 0;
      "net.ipv4.tcp_tw_reuse" = 1;
      "net.ipv4.tcp_window_scaling" = 1;
      "net.ipv4.tcp_sack" = 1;
      "net.core.netdev_max_backlog" = 16384;
      "net.core.rmem_max" = 134217728;
      "net.core.wmem_max" = 134217728;
      "net.core.rmem_default" = 16777216;
      "net.core.wmem_default" = 16777216;
      "net.ipv4.tcp_rmem" = "4096 87380 134217728";
      "net.ipv4.tcp_wmem" = "4096 65536 134217728";
      "net.core.default_qdisc" = "fq";
      
      # === SCHEDULER ===
      "kernel.sched_min_granularity_ns" = 2000000;
      "kernel.sched_wakeup_granularity_ns" = 3000000;
      "kernel.sched_migration_cost_ns" = 500000;
      "kernel.sched_latency_ns" = 20000000;
      "kernel.sched_autogroup_enabled" = 0;
      "kernel.sched_child_runs_first" = 0;
      "kernel.timer_migration" = 0;
      
      # === FILESYSTEM ===
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;
      "vm.dirty_writeback_centisecs" = 1500;
      "vm.dirty_expire_centisecs" = 3000;
      
      # === FILE HANDLES ===
      "fs.file-max" = 2097152;
      "fs.inotify.max_user_watches" = 524288;
      "fs.inotify.max_user_instances" = 8192;
      
      # === KERNEL ===
      "kernel.panic" = 10;
      "kernel.panic_on_oops" = 1;
    };

    boot.kernelModules = ["hugepages"];

    systemd.tmpfiles.rules = [
      "w /sys/kernel/mm/transparent_hugepage/enabled - - - - always"
      "w /sys/kernel/mm/transparent_hugepage/defrag - - - - defer+madvise"
      "w /sys/kernel/mm/transparent_hugepage/khugepaged/defrag - - - - 1"
    ];

    environment.sessionVariables = {
      MESA_GLTHREAD = "true";
      MESA_NO_ERROR = "1";
      MESA_DISK_CACHE_SIZE = "8192M";
      MESA_DISK_CACHE_SINGLE_FILE = "true";
      MESA_DISK_CACHE_DATABASE = "true";
      AMD_VULKAN_ICD = "RADV";
      RADV_PERFTEST = "nggc,sam,rt,nir";
      RADV_DEBUG = "zerovram";
      vblank_mode = "0";
      __GL_SYNC_TO_VBLANK = "0";
      PROTON_NO_ESYNC = "0";
      PROTON_NO_FSYNC = "0";
      SDL_THREAD_PRIORITY_POLICY = "2";
      SDL_VIDEODRIVER = "wayland";
    };

    services.udev.extraRules = ''
      ACTION=="add|change", KERNEL=="nvme[0-9]n[0-9]", ATTR{queue/scheduler}="none"
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="mq-deadline"
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{power/control}="on"
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/autosuspend", ATTR{power/autosuspend}="-1"
    '';

    programs.gamemode = {
      enable = true;
      settings = {
        general = {
          softrealtime = "auto";
          renice = -20;
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
            ${pkgs.libnotify}/bin/notify-send -u low "GameMode" "Activo" -t 2000
          ''}";
          end = "${pkgs.writeShellScript "gamemode-end" ''
            ${pkgs.libnotify}/bin/notify-send -u low "GameMode" "Desactivado" -t 2000
          ''}";
        };
      };
      enableRenice = true;
    };

    security.pam.loginLimits = [
      { domain = "@users"; type = "soft"; item = "rtprio"; value = "99"; }
      { domain = "@users"; type = "hard"; item = "rtprio"; value = "99"; }
      { domain = "@users"; type = "soft"; item = "nice"; value = "-20"; }
      { domain = "@users"; type = "hard"; item = "nice"; value = "-20"; }
      { domain = "@users"; type = "soft"; item = "memlock"; value = "unlimited"; }
      { domain = "@users"; type = "hard"; item = "memlock"; value = "unlimited"; }
    ];

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

    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "clear-cache" ''
        #!/usr/bin/env bash
        sync && echo 3 | sudo tee /proc/sys/vm/drop_caches > /dev/null
        ${pkgs.libnotify}/bin/notify-send "Cache" "Limpiada" -u low -t 1000
      '')
      schedtool
    ];
  };
}
