{
  config,
  lib,
  ...
}: {
  options = {
    Persistente.enable = lib.mkEnableOption "Habilitar Persistencia";
  };

  config = lib.mkIf config.Persistente.enable {
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
              files = [
                ".p10k.zsh"
                ".zshrc"
              ];
            };
          };
        };
      };
    };
  };
}
