# Modules/Drivers/CPU/AMD/AMD-CPU.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  options.CPU-AMD.enable = lib.mkEnableOption "CPU AMD - Máximo rendimiento gaming";

  config = lib.mkIf config.CPU-AMD.enable {
    hardware.cpu.amd.updateMicrocode = true;

    boot = {
      kernelModules = ["kvm-amd" "msr"];
      
      kernelParams = [
        "mitigations=off"
        "amd_iommu=on"
        "iommu=pt"
        "transparent_hugepage=always"
        "hugepagesz=2M"
        "default_hugepagesz=2M"
        "preempt=full"
        "nosmt=off"
      ];
    };

    powerManagement = {
      enable = true;
      cpuFreqGovernor = "performance";
    };

    systemd.tmpfiles.rules = [
      "w /sys/devices/system/cpu/cpufreq/boost - - - - 1"
      "w /sys/devices/system/cpu/cpu*/cpuidle/state3/disable - - - - 1"
      "w /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq - - - - 3600000"
    ];

    services.irqbalance.enable = true;

    environment.systemPackages = with pkgs; [
      lm_sensors
      cpufrequtils
    ];

    environment.sessionVariables = {
      OMP_NUM_THREADS = "12";
      OMP_PROC_BIND = "true";
      OMP_PLACES = "cores";
    };

    security.pam.loginLimits = [
      { domain = "@users"; type = "soft"; item = "rtprio"; value = "99"; }
      { domain = "@users"; type = "hard"; item = "rtprio"; value = "99"; }
      { domain = "@users"; type = "soft"; item = "nice"; value = "-20"; }
      { domain = "@users"; type = "hard"; item = "nice"; value = "-20"; }
      { domain = "@users"; type = "soft"; item = "memlock"; value = "unlimited"; }
      { domain = "@users"; type = "hard"; item = "memlock"; value = "unlimited"; }
    ];
  };
}
