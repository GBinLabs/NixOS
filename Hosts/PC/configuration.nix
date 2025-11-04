# Hosts/PC/configuration.nix
{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../Modules/default.nix
    ./disko.nix
  ];

  CPU-AMD.enable = true;
  GPU-AMD.enable = true;
  Zram.enable = true;
  Steam.enable = true;
  Persistente-PC.enable = true;
  Reset.enable = true;
  Red-PC.enable = true;

  users.mutableUsers = false;
  users.users.german = {
    isNormalUser = true;
    description = "Germán N. González";
    extraGroups = ["networkmanager" "wheel" "audio" "video" "gamemode"];
    hashedPasswordFile = config.sops.secrets.usuario-german.path;
  };

  system.stateVersion = "24.11";
}
