{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../NixOS-modules/default.nix
    ./disko.nix
  ];

  # Drivers
  # CPU.
  CPU-AMD.enable = false;
  CPU-Intel.enable = true;

  # GPU.
  GPU-AMD.enable = false;
  GPU-Nvidia.enable = false;
  # Final Drivers.

  # Impermanence.
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
  };
  # Final Usuarios.

  # ¡DEJAR ASI!#
  system.stateVersion = "24.11";
}
