# Modules/Drivers/GPU/AMD/AMD-GPU.nix
{config, pkgs, lib, ...}: {
  options.GPU-AMD.enable = lib.mkEnableOption "GPU AMD con undervolt";

  config = lib.mkIf config.GPU-AMD.enable {
    hardware = {
      amdgpu = {
        opencl.enable = true;
        initrd.enable = true;
      };
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [
          rocmPackages.clr.icd
          rocmPackages.clr
        ];
      };
    };

    environment.sessionVariables = {
      AMD_VULKAN_ICD = "RADV";
      RADV_PERFTEST = "nggc,sam";
    };

    boot = {
      kernelModules = ["amdgpu"];
      kernelParams = [
        "amdgpu.ppfeaturemask=0xffffffff"
        "amdgpu.gpu_recovery=1"
      ];
      initrd.kernelModules = ["amdgpu"];
    };

    systemd.services.amd-gpu-undervolt = {
      description = "AMD GPU Undervolt y optimización";
      wantedBy = ["multi-user.target"];
      after = ["multi-user.target"];
      serviceConfig = {
        Type = "oneshot";
        RemainAfterExit = true;
        ExecStart = pkgs.writeShellScript "amd-gpu-setup" ''
          CARD=$(ls /sys/class/drm/card*/device/pp_od_clk_voltage 2>/dev/null | head -1)
          if [ -n "$CARD" ]; then
            CARDPATH=$(dirname "$CARD")
            
            # Modo manual
            echo "manual" > "$CARDPATH/power_dpm_force_performance_level"
            
            # Configurar estados GPU (RX 5500 XT)
            # Estado 0: 800MHz @ 750mV
            # Estado 1: 1300MHz @ 800mV
            # Estado 2: 1717MHz @ 950mV (reducido de ~1100mV stock)
            
            echo "s 0 800 750" > "$CARD"
            echo "s 1 1300 800" > "$CARD"
            echo "s 2 1717 950" > "$CARD"
            echo "c" > "$CARD"
            
            # Configurar ventilador más agresivo
            echo "1" > "$CARDPATH/hwmon/hwmon"*/pwm1_enable
            echo "120" > "$CARDPATH/hwmon/hwmon"*/pwm1
            
            # Habilitar performance auto
            echo "auto" > "$CARDPATH/power_dpm_force_performance_level"
          fi
        '';
      };
    };

    services.lact = {
      enable = true;
      package = pkgs.lact;
    };

    environment.systemPackages = with pkgs; [
      radeontop
      lact
      (writeShellScriptBin "gpu-stats" ''
        watch -n1 'radeontop -d - -l 1 | grep -E "gpu|vram"'
      '')
    ];
  };
}
