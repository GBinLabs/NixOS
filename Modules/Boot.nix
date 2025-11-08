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

    # Kernel LTS estable (no latest) para evitar regresiones de audio
    kernelPackages = pkgs.linuxPackages_latest;

    kernelParams = [
      "quiet"
      "splash"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "vt.global_cursor_default=0"
      "nowatchdog"
      # "transparent_hugepage=always"  # <-- ELIMINADO (causa latencia irregular)
      "vm.max_map_count=2147483642"
      # "mitigations=off"  # <-- Opcional: quita si tienes inestabilidad
    ];

    initrd = {
      compressor = "zstd";
      compressorArgs = ["-19" "-T0"];
      verbose = false;
      systemd.enable = true;
    };

    plymouth = {
      enable = true;
      theme = "bgrt";
      extraConfig = ''
        DeviceScale=1
      '';
    };

    consoleLogLevel = 0;
    blacklistedKernelModules = ["iTCO_wdt" "iTCO_vendor_support" "pcspkr"];
  };
}
