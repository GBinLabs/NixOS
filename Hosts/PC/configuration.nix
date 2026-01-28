{
  config,
  ...
}:
{
  imports = [
    ../../Modules/default.nix
    ./disko.nix
  ];

  hardware.pc.enable = true;
  Steam.enable = true;
  Persistencia = {
    enable = true;
    extraUserDirectories = [
      ".local/share/Steam"
      ".local/share/PrismLauncher"
      ".local/share/Hytale"
    ];
  };
  Reset.enable = true;
  Red-PC.enable = true;

  users.mutableUsers = false;
  users.users.german = {
    isNormalUser = true;
    description = "Germán N. González";
    extraGroups = [
      "networkmanager"
      "wheel"
      "audio"
      "video"
      "gamemode"
    ];
    hashedPasswordFile = config.sops.secrets.usuario-german.path;
  };

  system.stateVersion = "24.11";
}
