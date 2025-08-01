{config, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../NixOS-modules/default.nix
    ./disko.nix
  ];

  # Drivers
  # CPU.
  CPU-AMD.enable = true;
  CPU-Intel.enable = false;

  # GPU.
  GPU-AMD.enable = true;
  GPU-Intel.enable = false;
  GPU-Nvidia.enable = false;
  # Final Drivers.

  # Impermanence.

  # Persistencia.
  Persistente-Netbook.enable = false;
  Persistente-Notebook.enable = false;
  Persistente-PC.enable = true;
  # Final Persistencia.

  # Reseteo.
  Reset.enable = true;
  Reset-Netbook.enable = false;
  # Final Reseteo.

  # Final Impermanence.
  
  # Juegos.
  Gamemode.enable = true;
  Steam.enable = true;

  # RED.
  Red-Netbook.enable = false;
  Red-Notebook.enable = false;
  Red-PC.enable = true;
  # Final RED.
  
  environment.variables.AMD_VULKAN_ICD = "RADV";

  # Usuarios
  users.mutableUsers = false;
  users.users.german = {
    isNormalUser = true;
    home = "/home/german";
    description = "Germán N. González";
    extraGroups = ["networkmanager" "wheel" "audio" "gamemode"];
    hashedPasswordFile = config.sops.secrets.usuario-german.path;
  };

  users.users.tecnico = {
    isNormalUser = true;
    description = "Técnico";
    extraGroups = [];
    initialPassword = "1234";
  };
  # Final Usuarios.

  # DEJAR ASI #
  system.stateVersion = "24.11";
}
