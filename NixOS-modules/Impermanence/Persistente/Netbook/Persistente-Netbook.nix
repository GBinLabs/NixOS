{
  config,
  lib,
  ...
}: {
  options = {
    Persistente-Netbook.enable = lib.mkEnableOption "Habilitar Persistencia-Netbook";
  };

  config = lib.mkIf config.Persistente-Netbook.enable {
    fileSystems = {
      "/persist" = {
        neededForBoot = true;
      };
    };

    environment = {
      persistence = {
        "/persist" = {
          enable = true;
          hideMounts = true;
          directories = [
            "/var/lib/nixos"
            "/etc/NetworkManager/system-connections"
          ];

          users = {
            german = {
              directories = [
                "Descargas"
                "Documentos"
                "Imágenes"
                "Música"
                "Vídeos"
                ".GitHub"
                ".ssh"
                ".config/sops"
                ".config/git"
                ".config/Joplin"
                ".config/joplin-desktop"
              ];
            };
          };
        };
      };
    };
  };
}
