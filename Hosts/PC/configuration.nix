{config, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../Modules/default.nix
    ./disko.nix
  ];

  # Drivers
  # CPU.
  CPU-AMD = {
    enable = true;
    performanceProfile = "gaming";
    enableSchedulerTweaks = true;
    enableCPUBoost = true;
  };
  CPU-Intel.enable = false;

  # GPU.
  GPU-AMD = {
    enable = true;
    performanceProfile = "gaming";
    enableTuning = false; # true si quieres overclock/control manual
  };
  GPU-Intel = {
    enable = false;
    #vaDriver = "iHD";  # O "auto"
    #enableOptimizations = true;
  };
  GPU-Nvidia = {
    enable = false;
    #primeMode = "reverseSync"; # NVIDIA solo cuando se necesita
    #intelBusId = "PCI:0:2:0"; # Verificar con: lspci | grep VGA
    #nvidiaBusId = "PCI:4:0:0"; # Verificar con: lspci | grep NVIDIA
    #enableUtils = true;
  };
  # Final Drivers.

  # Zram.
  Zram.enable = true;
  # Final Zram.

  # Impermanence.
  Persistente-PC.enable = true;
  Persistente.enable = false;
  Reset.enable = true;
  Reset-Netbook.enable = false;
  # Final Impermanence.

  # RED.
  Red-Netbook.enable = false;
  Red-Notebook.enable = false;
  Red-PC.enable = true;
  # Final RED.

  # Steam.
  Steam.enable = true;
  # Final Steam.

  # Usuarios
  users.mutableUsers = false;
  users.users.german = {
    isNormalUser = true;
    home = "/home/german";
    description = "Germán N. González";
    extraGroups = ["networkmanager" "wheel" "audio" "gamemode"];
    hashedPasswordFile = config.sops.secrets.usuario-german.path;
  };

  #users.users.Tecnico = {
  #  isNormalUser = true;
  #  description = "Técnico";
  #  extraGroups = [];
  #  initialPassword = "1234";
  #};
  # Final Usuarios.

  # DEJAR ASI #
  system.stateVersion = "24.11";
}
