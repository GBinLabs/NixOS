# Hosts/Netbook/configuration.nix
{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../Modules/default.nix
    ./disko.nix
  ];

  CPU-Intel.enable = true;
  GPU-Intel.enable = true;
  Zram.enable = true;
  Persistente.enable = true;
  Reset-Netbook.enable = true;
  Red-Netbook.enable = true;

  users.mutableUsers = false;
  users.users.german = {
    isNormalUser = true;
    description = "Germán N. González";
    extraGroups = ["networkmanager" "wheel" "audio" "video"];
    hashedPasswordFile = config.sops.secrets.usuario-german.path;
  };

  system.stateVersion = "24.11";
}
