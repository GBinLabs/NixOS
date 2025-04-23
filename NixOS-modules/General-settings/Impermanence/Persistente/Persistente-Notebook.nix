{
  config,
  lib,
  ...
}: {
  options = {
    Persistente-Notebook.enable = lib.mkEnableOption "Habilitar Persistencia-Notebook";
  };

  config = lib.mkIf config.Persistente-Notebook.enable {
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
        ];
      };
    };
  };
}
