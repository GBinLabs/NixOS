# Modules/Boot.nix
{pkgs, ...}: {
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5; # Reducido a 5
        consoleMode = "max"; # Resolución máxima
        editor = false; # Deshabilitar editor (seguridad + velocidad)
      };
      efi.canTouchEfiVariables = true;
      timeout = 0; # Boot instantáneo (0 = sin menú)
    };

    kernelPackages = pkgs.linuxPackages_zen;

    kernelParams = [
      # === PERFORMANCE ===
      "mitigations=off"
      "nowatchdog"
      "nmi_watchdog=0"
      "preempt=full"
      "threadirqs"
      "nohz=on"
      "transparent_hugepage=always"
      "hugepagesz=2M"
      "default_hugepagesz=2M"
      "hugepages=1024"
      "vm.max_map_count=2147483642"
      "split_lock_detect=off"

      # === BOOT RÁPIDO ===
      "quiet"
      "loglevel=3"
      "systemd.show_status=false"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
      "vt.global_cursor_default=0"

      # === AHORRO DE TIEMPO ===
      "nowatchdog"
      "modprobe.blacklist=iTCO_wdt,iTCO_vendor_support"

      # === ADICIONALES PARA PERFORMANCE ===
      "processor.max_cstate=1" # Reduce latencia CPU
      "intel_idle.max_cstate=1" # Solo Intel
      "idle=poll" # Máximo rendimiento (más consumo)

      # Network
      "net.ifnames=0" # Nombres de red simples

      # Filesystem
      "rootflags=noatime,nodiratime"

      # Disable debug
      "debug.exception-trace=0"
    ];

    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "sd_mod"
      ];

      compressor = "zstd";
      compressorArgs = ["-19" "-T0"];

      # Verbose OFF
      verbose = false;
    };

    # === SIN PLYMOUTH (menos overhead) ===
    plymouth.enable = false;

    # === CONSOLA ===
    consoleLogLevel = 0;

    # === KERNEL MODULES BLACKLIST ===
    blacklistedKernelModules = [
      # Watchdogs (innecesarios)
      "iTCO_wdt"
      "iTCO_vendor_support"

      # PC Speaker (molesto)
      "pcspkr"

      # Bluetooth (si no lo usas)
      # "btusb" "bluetooth"
    ];
  };
}
