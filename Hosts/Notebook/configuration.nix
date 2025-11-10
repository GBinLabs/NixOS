{config, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../Modules/default.nix
    ./disko.nix
  ];

  # Drivers
  # CPU.
  CPU-AMD.enable = false;
  CPU-Intel.enable = true;

  # GPU.
  GPU-AMD = {
    enable = false;
    #performanceProfile = "gaming";
    #enableTuning = false; # true si quieres overclock/control manual
  };
  GPU-Intel = {
    enable = false;
    #vaDriver = "iHD";  # O "auto"
    #enableOptimizations = true;
  };
  GPU-Nvidia = {
    enable = true;
    primeMode = "reverseSync"; # NVIDIA solo cuando se necesita
    intelBusId = "PCI:0:2:0"; # Verificar con: lspci | grep VGA
    nvidiaBusId = "PCI:4:0:0"; # Verificar con: lspci | grep NVIDIA
    enableUtils = true;
  };
  # Final Drivers.

  # Impermanence.
  Persistente-PC.enable = false;
  Persistente.enable = true;
  Reset.enable = true;
  Reset-Netbook.enable = false;
  # Final Impermanence.

  # RED.
  Red-Netbook.enable = false;
  Red-Notebook.enable = true;
  Red-PC.enable = false;
  # Final RED.

  # Steam.
  Steam.enable = false;
  # Final Steam.

  # Variables de entorno para sistema híbrido Intel+NVIDIA
  environment.sessionVariables = {
    # Intel para tareas generales
    LIBVA_DRIVER_NAME = "i965"; # i965 para Intel de 4ta generación
    # NVIDIA usará VDPAU cuando esté activa
    VDPAU_DRIVER = "nvidia";
  };

  # Usuarios
  users.mutableUsers = false;
  users.users.german = {
    isNormalUser = true;
    home = "/home/german";
    description = "Germán N. González";
    extraGroups = ["networkmanager" "wheel" "audio"];
    hashedPasswordFile = config.sops.secrets.usuario-german.path;
  };
  # Final usuario

  # DEJAR ASI #
  system.stateVersion = "24.11";
}
