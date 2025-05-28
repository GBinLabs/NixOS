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
          "Descargas"
          "Documentos"
          "Música"
          "Imágenes"
          "Videos"
          ".GitHub"
          ".ssh"
          ".config/sops"
          ".config/git"
          ".config/Joplin"
          ".config/joplin-desktop"
          ".local/share/Steam"
          ".local/share/PrismLauncher"
        ];
      };
    };
  };
}
