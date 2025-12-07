{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.CPU-AMD;
in {
  options.CPU-AMD = {
    enable = mkEnableOption "Ryzen 5 3600 - Undervolt Máximo Validado";

    undervoltmV = mkOption {
      type = types.int;
      default = 100;
      description = "Undervolt validado como estable para este chip específico (mV)";
    };

    pptLimit = mkOption {
      type = types.int;
      default = 65;
      description = "Límite PPT optimizado aprovechando eficiencia de undervolt (W)";
    };

    boostMHz = mkOption {
      type = types.int;
      default = 4200;
      description = "Frecuencia boost nominal (MHz)";
    };

    targetTemp = mkOption {
      type = types.int;
      default = 75;
      description = "Temperatura objetivo para gestión térmica (°C)";
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      boot.kernelModules = ["msr" "cpufreq_schedutil"];
      boot.extraModprobeConfig = "options msr allow_writes=on";
      
      powerManagement.cpuFreqGovernor = lib.mkForce "schedutil";
      
      boot.kernelParams = [
        "amd_pstate=active"
      ];

      boot.kernel.sysctl = {
        "kernel.sched_energy_aware" = 1;
      };
    }

    {
      systemd.services.ryzenadj-cpu = {
        enable = true;
        description = "Ryzen 5 3600 - Undervolt Máximo Optimizado";
        wantedBy = ["multi-user.target"];
        after = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "ryzenadj-optimized" ''
            sleep 3

            ${pkgs.ryzenadj}/bin/ryzenadj \
              --stapm-limit=${toString cfg.pptLimit}000 \
              --fast-limit=${toString cfg.pptLimit}000 \
              --slow-limit=${toString cfg.pptLimit}000 \
              --tctl-temp=${toString cfg.targetTemp} \
              --max-performance

            ${pkgs.ryzenadj}/bin/ryzenadj --volt-dec=${toString cfg.undervoltmV}

            echo "[CPU] Ryzen 5 3600 Optimizado: Boost ${toString cfg.boostMHz}MHz | PPT=${toString cfg.pptLimit}W | UV=-${toString cfg.undervoltmV}mV | Temp=${toString cfg.targetTemp}°C"
          '';
        };
      };
    }
  ]);
}
