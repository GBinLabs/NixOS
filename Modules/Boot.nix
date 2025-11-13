{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 3;
        consoleMode = "max";
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };

    kernelPackages = pkgs.linuxPackages_cachyos;

    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "vt.global_cursor_default=0"
      "nowatchdog"
      "vm.max_map_count=2147483642"
    ];

    initrd = {
      compressor = "zstd";
      compressorArgs = ["-10" "-T0"];
      verbose = false;
      systemd.enable = true;
    };

    plymouth = {
      enable = true;
      theme = "bgrt";
    };

    consoleLogLevel = 0;
    blacklistedKernelModules = ["iTCO_wdt" "iTCO_vendor_support" "pcspkr"];
  };
  services.scx.enable = true;
}
