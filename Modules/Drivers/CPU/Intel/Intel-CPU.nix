# Modules/Drivers/CPU/Intel/Intel-CPU.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    CPU-Intel = {
      enable = lib.mkEnableOption "Habilitar CPU-Intel";

      powerProfile = lib.mkOption {
        type = lib.types.enum ["performance" "balanced" "powersave"];
        default = "balanced";
        description = "Perfil de energía";
      };
    };
  };

  config = lib.mkIf config.CPU-Intel.enable {
    hardware.cpu.intel.updateMicrocode = true;

    # Governor según perfil
    powerManagement = {
      enable = true;
      cpuFreqGovernor = lib.mkMerge [
        (lib.mkIf (config.CPU-Intel.powerProfile == "performance") "performance")
        (lib.mkIf (config.CPU-Intel.powerProfile == "balanced") "powersave")
        (lib.mkIf (config.CPU-Intel.powerProfile == "powersave") "powersave")
      ];
    };

    # Throttled para controlar throttling en Intel
    services.throttled = {
      enable = true;
    };

    # Parámetros del kernel para Gemini Lake
    boot.kernelParams = [
      # Intel P-states (mejor que ACPI para Gemini Lake)
      "intel_pstate=active"

      # Turbo boost (N4020 no tiene turbo, pero no afecta)
      "intel_pstate.max_perf_pct=100"

      # C-states para ahorro de energía
      "processor.max_cstate=7" # Gemini Lake soporta C7

      # Mitigaciones (deshabilitar SOLO si no usas la netbook para datos sensibles)
      # "mitigations=off"  # +10-15% rendimiento pero MENOS SEGURO
    ];

    # Kernel sysctl optimizado para bajo consumo
    boot.kernel.sysctl = {
      # Scheduler para laptops
      "kernel.sched_migration_cost_ns" = 5000000;
      "kernel.sched_min_granularity_ns" = 10000000;

      # Ahorro de energía
      "vm.laptop_mode" = 5;
      #"vm.dirty_ratio" = 60;
      #"vm.dirty_background_ratio" = 20;
      "vm.dirty_writeback_centisecs" = 6000; # 60s

      # Swappiness moderado (para netbooks con poca RAM)
      #"vm.swappiness" = 60;
      #"vm.vfs_cache_pressure" = 50;
    };

    # Herramientas de monitoreo
    environment.systemPackages = with pkgs; [
      intel-gpu-tools
      powertop
      tlp # Para gestión de energía
    ];

    # TLP para gestión avanzada de energía
    services.tlp = {
      enable = true;
      settings = {
        # CPU
        CPU_SCALING_GOVERNOR_ON_AC = "powersave";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

        CPU_ENERGY_PERF_POLICY_ON_AC = "balance_performance";
        CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";

        CPU_MIN_PERF_ON_AC = 0;
        CPU_MAX_PERF_ON_AC = 100;
        CPU_MIN_PERF_ON_BAT = 0;
        CPU_MAX_PERF_ON_BAT = 60; # Limitar en batería

        CPU_BOOST_ON_AC = 1;
        CPU_BOOST_ON_BAT = 0;

        # Discos
        DISK_DEVICES = "sda";
        DISK_APM_LEVEL_ON_AC = "254";
        DISK_APM_LEVEL_ON_BAT = "128";

        # USB
        USB_AUTOSUSPEND = 1;
        USB_BLACKLIST_PHONE = 1;

        # Audio
        SOUND_POWER_SAVE_ON_AC = 0;
        SOUND_POWER_SAVE_ON_BAT = 1;

        # WiFi
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "on";
      };
    };
  };
}
