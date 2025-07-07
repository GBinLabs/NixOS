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
  GPU-Intel.enable = false;
  GPU-Nvidia.enable = true;
  # Final Drivers.

  # Impermanence.

  # Persistencia.
  Persistente-Netbook.enable = false;
  Persistente-Notebook.enable = true;
  Persistente-PC.enable = false;
  # Final Persistencia.

  # Reseteo.
  Reset.enable = true;
  Reset-Netbook.enable = false;
  # Final Reseteo.

  # Final Impermanence.

  # Juegos.
  Steam.enable = false;
  Gamemode.enable = false;
  # Final Juegos.

  # RED.
  Red-Netbook.enable = false;
  Red-Notebook.enable = true;
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

  # ¡DEJAR ASI!
  system.stateVersion = "24.11";
}
