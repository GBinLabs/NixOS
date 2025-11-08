{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.CPU-AMD;
  FID = toString (cfg.frequencyMHz * 8 / 100);
  VID = toString cfg.vid;
  FREQ = toString cfg.frequencyMHz;
in
{
  options.CPU-AMD = {
    enable = mkEnableOption "AMD Ryzen 5 3600 - undervolt nativo";
    vid = mkOption { type = types.int; default = 56; };
    frequencyMHz = mkOption { type = types.int; default = 4100; };
  };

  config = mkIf cfg.enable (mkMerge [
    {
      boot.kernelModules = [ "msr" ];
      boot.extraModprobeConfig = "options msr allow_writes=on";
      powerManagement.cpuFreqGovernor = "schedutil";
      
      systemd.tmpfiles.rules = [
        "Z /dev/cpu 0755 root root - -"
        "Z /dev/cpu/*/msr 0660 root wheel - -"
      ];
    }

    {
      systemd.services.amd-cpu-undervolt = {
        enable = true;
        description = "Undervolt Ryzen 5 3600";
        wantedBy = [ "multi-user.target" ];
        after = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          # CORREGIDO: Usar msr-tools (paquete correcto)
          ExecStart = pkgs.writeShellScript "cpu-uv" ''
            for cpu in /dev/cpu/[0-5]; do
              ${pkgs.msr-tools}/bin/wrmsr -p $(echo $cpu | tr -d '/dev/cpu/') 0xc0010293 $(( (0x100000 + ${FID}) << 8 | (${VID} & 0xff) ))
            done
          '';
        };
      };
    }

    {
      environment.systemPackages = with pkgs; [
        lm_sensors
        msr-tools  # CORREGIDO: Paquete correcto
        stress-ng
        (writeShellScriptBin "cpu-status" ''
          echo "Ryzen 5 3600: ${FREQ}MHz @ VID=${VID}"
          sensors k10temp-pci-00c3 2>/dev/null | grep Tctl || echo "Temp: N/A"
        '')
      ];
    }

    {
      warnings = optional cfg.enable
        "CPU-AMD: Undervolt activado (${FREQ}MHz @ VID=${VID})";
    }
  ]);
}
