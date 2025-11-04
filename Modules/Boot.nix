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
      # === BOOT RÁPIDO ===
      "quiet"
      "loglevel=3"
      "systemd.show_status=false"

      # === PERFORMANCE (conservador) ===
      "nowatchdog"
      "nmi_watchdog=0"
      "transparent_hugepage=always"
      "vm.max_map_count=2147483642"

      # === AMD ESPECÍFICO ===
      "amd_iommu=on"
      "iommu=pt"

      # === REMOVER TEMPORALMENTE ===
      # "mitigations=off"  # Reactivar después si todo funciona
      # "idle=poll"  # Demasiado agresivo
      # "processor.max_cstate=1"  # Probar sin esto primero

      # Network
      "net.ifnames=0"

      # Filesystem
      "rootflags=noatime,nodiratime"
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
