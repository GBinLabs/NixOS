{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../Modules/default.nix
    ./disko.nix
  ];

  # Drivers
  # CPU.
  CPU-AMD.enable = false;
  CPU-Intel.enable = true;

  # GPU.
  GPU-AMD.enable = false;
  GPU-Intel.enable = false;
  # Final Drivers.

  # Impermanence.
  Persistente-PC.enable = false;
  Persistente-Netbook.enable = true;
  Reset.enable = false;
  Reset-Netbook.enable = true;
  # Final Impermanence.

  # RED.
  Red-Netbook.enable = true;
  Red-PC.enable = false;
  # Final RED.

  # Usuarios.
  users.mutableUsers = false;
  users.users.german = {
    isNormalUser = true;
    description = "Germán N. González";
    extraGroups = ["networkmanager" "wheel" "audio"];
    hashedPasswordFile = config.sops.secrets.usuario-german.path;
    initialPassword = "1234";
  };
  # Final Usuarios.

  # ¡DEJAR ASI!#
  system.stateVersion = "24.11";
}
