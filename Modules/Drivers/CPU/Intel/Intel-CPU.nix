# Modules/Drivers/CPU/Intel/Intel-CPU.nix
{
  config,
  lib,
  pkgs,
  ...
}: {
  options.CPU-Intel.enable = lib.mkEnableOption "CPU Intel - Máximo rendimiento";

  config = lib.mkIf config.CPU-Intel.enable {
    hardware.cpu.intel.updateMicrocode = true;

    powerManagement = {
      enable = true;
      cpuFreqGovernor = "performance";
    };

    services.throttled.enable = true;

    boot.kernelParams = [
      "intel_pstate=active"
      "intel_pstate.max_perf_pct=100"
      "intel_pstate.min_perf_pct=100"
      "processor.max_cstate=1"
      "intel_idle.max_cstate=1"
      "transparent_hugepage=always"
    ];

    systemd.tmpfiles.rules = [
      "w /sys/devices/system/cpu/intel_pstate/no_turbo - - - - 0"
      "w /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq - - - - 2600000"
      "w /sys/devices/system/cpu/cpu*/cpufreq/scaling_max_freq - - - - 2600000"
    ];

    environment.systemPackages = with pkgs; [
      intel-gpu-tools
      powertop
    ];
  };
}
