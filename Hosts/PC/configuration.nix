# Hosts/PC/configuration.nix
{config, ...}: {
  imports = [
    ../../Modules/default.nix
    ./disko.nix
  ];
  
  Persistencia.enable = true;
  Reset.enable = true;
  Red-PC.enable = true;

  users.mutableUsers = false;
  users.users.german = {
    isNormalUser = true;
    description = "Germán N. González";
    extraGroups = ["networkmanager" "wheel" "audio" "video"];
    hashedPasswordFile = config.sops.secrets.usuario-german.path;
  };

  system.stateVersion = "24.11";
}
