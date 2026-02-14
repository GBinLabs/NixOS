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
            configurationLimit = 10;
            consoleMode = "max";
            editor = false;
          };
          efi.canTouchEfiVariables = true;
          timeout = 0;
        };

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

        kernel.sysctl = {
          "net.core.netdev_max_backlog" = 16384;
          "net.core.somaxconn" = 8192;
          "net.ipv4.tcp_fastopen" = 3;
          "vm.dirty_ratio" = 10;
          "vm.dirty_background_ratio" = 5;
        };
      };

      hardware.bluetooth = {
        enable = false;
        powerOnBoot = false;
      };

      networking = {
        networkmanager = {
          enable = true;
        };
      };
    }

    (lib.mkIf config.hardware.pc.enable {
      boot = {
        kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v3;
        kernelParams = [
          "video=HDMI-A-1:1920x1080@75"
          "amdgpu.ppfeaturemask=0xffffffff"
          "amdgpu.dpm=1"
          "processor.max_cstate=1"
          "intel_idle.max_cstate=0"
          "nowatchdog"
          "nmi_watchdog=0"
          "split_lock_detect=off"
          "threadirqs"
          "preempt=full"
          "clocksource=tsc"
          "tsc=reliable"
          "amd_pstate=guided"
          "amdgpu.runpm=0"
        ];
        kernelModules = [ "amdgpu" ];
      };
    })

    (lib.mkIf config.hardware.netbook.enable {
      boot = {
        kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest-lto-x86_64-v2;
        kernelParams = [
          "i915.enable_fbc=1"
          "i915.enable_psr=1"
          "nowatchdog"
          "nmi_watchdog=0"
          "threadirqs"
          "acpi_osi=Linux"
          "acpi_backlight=native"
          "preempt=full"
          "clocksource=tsc"
          "tsc=reliable"
        ];
        kernelModules = [ "i915" ];
      };
    })
  ];
}
