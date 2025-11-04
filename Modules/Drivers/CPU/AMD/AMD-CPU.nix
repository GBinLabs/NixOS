# Modules/Drivers/CPU/AMD/AMD-CPU.nix
{config, pkgs, lib, ...}: {
  options.CPU-AMD.enable = lib.mkEnableOption "CPU AMD con undervolt";

  config = lib.mkIf config.CPU-AMD.enable {
    hardware.cpu.amd.updateMicrocode = true;

    boot = {
      kernelModules = ["kvm-amd" "msr" "zenpower"];
      kernelParams = [
        "amd_iommu=on"
        "iommu=pt"
        "amd_pstate=active"
        "amd_pstate.shared_mem=1"
      ];
    };

    powerManagement = {
      enable = true;
      cpuFreqGovernor = "schedutil";
    };

    systemd.services.amd-undervolt = {
      description = "AMD Ryzen Undervolt agresivo";
      wantedBy = ["multi-user.target"];
      after = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "amd-undervolt" ''
          # Configurar TDP y límites de energía
          echo 65000000 > /sys/class/hwmon/hwmon0/power1_cap || true
          
          # Configurar voltaje máximo y offset
          for cpu in /sys/devices/system/cpu/cpu*/cpufreq/; do
            echo 1100000 > ''${cpu}scaling_max_freq 2>/dev/null || true
            echo performance > ''${cpu}energy_performance_preference 2>/dev/null || true
          done
          
          # Habilitar boost controlado
          echo 1 > /sys/devices/system/cpu/cpufreq/boost
          
          # Optimizar estados C
          for state in /sys/devices/system/cpu/cpu*/cpuidle/state*/disable; do
            echo 0 > $state 2>/dev/null || true
          done
        '';
      };
    };

    systemd.tmpfiles.rules = [
      "w /sys/devices/system/cpu/cpufreq/boost - - - - 1"
      "w /sys/devices/system/cpu/cpu*/cpufreq/scaling_min_freq - - - - 2200000"
    ];

    services.irqbalance.enable = true;

    environment.systemPackages = with pkgs; [
      ryzenadj
      zenmonitor
    ];
  };
}
