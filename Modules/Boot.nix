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

    kernelPackages = pkgs.linuxPackages_cachyos;

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
    
    kernelParams = [
      "video=HDMI-A-1:1920x1080@75"
      "split_lock_detect=off"
      "nowatchdog"
      "processor.max_cstate=1"
      "intel_idle.max_cstate=1"
      "amdgpu.ppfeaturemask=0xffffffff"  
    ];
  };

  hardware.bluetooth = {
    enable = false;
    powerOnBoot = false;
  };
}
