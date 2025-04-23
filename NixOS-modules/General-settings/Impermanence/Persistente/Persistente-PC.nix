{
  config,
  lib,
  ...
}: {
  options = {
    Persistente-PC.enable = lib.mkEnableOption "Habilitar Persistencia-PC";
  };

  config = lib.mkIf config.Persistente-PC.enable {
    fileSystems."/persist".neededForBoot = true;

    environment.persistence."/persist" = {
      enable = true;
      hideMounts = true;
      directories = [
        "/var/lib/nixos"
        "/etc/NetworkManager/system-connections"
      ];

      users.german = {
        directories = [
          "Downloads"
          "Music"
          "Pictures"
          "Documents"
          "Videos"
          ".GitHub"
          ".ssh"
          ".config/sops"
          ".config/git"
          ".local/share/Steam"
          ".local/share/PrismLauncher"
        ];
      };
    };
  };
}
