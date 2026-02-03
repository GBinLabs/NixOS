{ config, ... }:
{
  imports = [
    ../../Modules/default.nix
    ./disko.nix
  ];

  hardware.netbook.enable = true;
  Persistencia.enable = true;
  Reset-Netbook.enable = true;
  Red-Netbook.enable = true;

  users.mutableUsers = false;
  users.users.german = {
    isNormalUser = true;
    description = "Germán N. González";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
    ];
    hashedPasswordFile = config.sops.secrets.usuario-german.path;
  };

  system.stateVersion = "24.11";
}
