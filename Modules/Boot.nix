{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = null;
        consoleMode = "max";
        editor = false;
      };
      efi.canTouchEfiVariables = true;
      timeout = 0;
    };

    kernelPackages = pkgs.linuxPackages_latest;

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
  };

  hardware.bluetooth = {
    enable = false;
    powerOnBoot = false;
  };
}
