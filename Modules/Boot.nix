# Modules/Boot.nix
{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
        consoleMode = "max";
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };

    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      "quiet"
      "loglevel=3"
      "systemd.show_status=false"
      "nowatchdog"
      "nmi_watchdog=0"
      "transparent_hugepage=always"
      "vm.max_map_count=2147483642"
      "net.ifnames=0"
      "rootflags=noatime,nodiratime"
    ];

    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod" "sdhci_pci"];
      compressor = "zstd";
      compressorArgs = ["-19" "-T0"];
      verbose = false;
    };

    plymouth.enable = false;
    consoleLogLevel = 0;

    blacklistedKernelModules = ["iTCO_wdt" "iTCO_vendor_support" "pcspkr"];
  };
}
