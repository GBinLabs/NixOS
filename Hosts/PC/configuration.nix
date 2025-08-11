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
  # Final Drivers.

  # Impermanence.
  Reset.enable = true;
  Reset-Netbook.enable = false;
  # Final Impermanence.

  # RED.
  Red-Netbook.enable = false;
  Red-PC.enable = true;
  # Final RED.

  # Usuarios
  users.mutableUsers = false;
  users.users.german = {
    isNormalUser = true;
    home = "/home/german";
    description = "Germán N. González";
    extraGroups = ["networkmanager" "wheel" "audio"];
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
