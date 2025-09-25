{config, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../Modules/default.nix
    ./disko.nix
  ];

  # Drivers
  # CPU.
  CPU-AMD.enable = true;
  CPU-Intel.enable = false;

  # GPU.
  GPU-AMD.enable = true;
  GPU-Intel.enable = false;
  # Final Drivers.

  # Impermanence.
  Persistente-PC.enable = true;
  Persistente-Netbook.enable = false;
  Reset.enable = true;
  Reset-Netbook.enable = false;
  # Final Impermanence.

  # RED.
  Red-Netbook.enable = false;
  Red-PC.enable = true;
  # Final RED.

  # Steam.
  Steam.enable = true;
  # Final Steam.

  # Usuarios
  users.mutableUsers = false;
  users.users.Bin = {
    isNormalUser = true;
    home = "/home/Bin";
    description = "Germán N. González";
    extraGroups = ["networkmanager" "wheel" "audio"];
    hashedPasswordFile = config.sops.secrets.usuario-Bin.path;
    initialPassword = "1234";
  };

  users.users.Tecnico = {
    isNormalUser = true;
    description = "Técnico";
    extraGroups = [];
    initialPassword = "1234";
  };
  # Final Usuarios.

  # DEJAR ASI #
  system.stateVersion = "24.11";
}
