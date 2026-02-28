{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    hardware.pc.enable = lib.mkEnableOption "Configuración de hardware para PC (AMD)";
    hardware.netbook.enable = lib.mkEnableOption "Configuración de hardware para Netbook (Intel N4020)";
  };

  config = lib.mkMerge [
    {
      boot = {
        loader = {
          systemd-boot = {
            enable = true;
            consoleMode = "max";
            editor = false;
          };
          efi.canTouchEfiVariables = true;
          timeout = 0;
        };
        
        kernelPackages = pkgs.linuxPackages_lqx;
        kernel.sysctl."vm.nr_hugepages" = 0;
	kernelParams = [ "transparent_hugepage=madvise" ];

        initrd = {
          compressor = "zstd";
          compressorArgs = [
            "-10"
            "-T0"
          ];
          verbose = false;
          systemd.enable = true;
        };

        plymouth = {
          enable = true;
          theme = "bgrt";
        };

        consoleLogLevel = 0;
      };

      hardware.bluetooth = {
        enable = false;
        powerOnBoot = false;
      };

      networking.networkmanager = {
        enable = true;
        dns = "systemd-resolved";
        wifi.powersave = false;
      };
      
      documentation.nixos.enable = false;
    }
    (lib.mkIf config.hardware.pc.enable {
      boot = {
        kernelParams = [
          "video=HDMI-A-1:1920x1080@75"
          "amd_pstate=active"
        ];
        kernelModules = [ "amdgpu" ];
      };
    })

    (lib.mkIf config.hardware.netbook.enable {
    boot = {
        kernelModules = [ "i915" ];
      };
    })
  ];
}
