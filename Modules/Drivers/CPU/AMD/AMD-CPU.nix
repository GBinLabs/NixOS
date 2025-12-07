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
    enable = mkEnableOption "Ryzen 5 3600 - Modo Performance Sweet Spot";

    # Parámetros ajustables (sweet spot para tu silicio)
    pptLimit = mkOption {
      type = types.int;
      default = 88; # +35% TDP stock, límite seguro A320
    };
    boostMHz = mkOption {
      type = types.int;
      default = 4200; # Máximo boost stock (no OC)
    };
    undervoltmV = mkOption {
      type = types.int;
      default = -50; # -50mV = sweet spot Zen 2
    };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      # === KERNEL Y DRIVER ===
      boot.kernelModules = ["msr" "cpufreq_performance"];
      boot.extraModprobeConfig = "options msr allow_writes=on";

      # Gobernador PERFORMANCE (crítico para latencia baja)
      powerManagement.cpuFreqGovernor = lib.mkForce "performance";
    }

    {
      # === RYZENADJ (método seguro y estable) ===
      systemd.services.ryzenadj-cpu = {
        enable = true;
        description = "Ryzen 5 3600 - Performance Optimized";
        wantedBy = ["multi-user.target"];
        after = ["multi-user.target"];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "ryzenadj-script" ''
            sleep 3

            # Aplicar límites de potencia (PPT/TDC/EDC)
            # Valores seguros para VRM de A320 (4 fases típico)
            ${pkgs.ryzenadj}/bin/ryzenadj \
              --stapm-limit=${toString cfg.pptLimit}000 \
              --fast-limit=${toString cfg.pptLimit}000 \
              --slow-limit=${toString cfg.pptLimit}000 \
              --tctl-temp=95 \
              --cclk-up-core=${toString cfg.boostMHz}0

            # Undervolt moderado (-50mV)
            ${pkgs.ryzenadj}/bin/ryzenadj --volt-dec=${toString cfg.undervoltmV}

            echo "[CPU] Ryzen 5 3600: ${toString cfg.boostMHz}MHz, PPT=${toString cfg.pptLimit}W, UV=${toString cfg.undervoltmV}mV"
          '';
        };
      };
    }

    {
      # === OPTIMIZACIONES DE JUEGOS ===
      boot.kernelParams = [
        "mitigations=off" # +2-3% FPS
        "amd_no_smt=off" # Deja SMT ON (mejor para CS2/Dota)
      ];
    }
  ]);
}
