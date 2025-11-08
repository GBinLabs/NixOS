# Hosts/Netbook/configuration.nix
{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../Modules/default.nix
    ./disko.nix
  ];

  # En configuration.nix
  CPU-Intel = {
    enable = true;
  };
  GPU-Intel = {
    enable = true;
    maxFreq = 550;
    rc6Level = 3;
  };
  Zram.enable = true;
  Persistencia.enable = true;
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
