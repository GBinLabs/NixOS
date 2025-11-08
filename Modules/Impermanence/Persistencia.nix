{
  config,
  lib,
  ...
}: {
  options.Persistencia = {
    enable = lib.mkEnableOption "Habilitar Persistencia";
    extraDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
    };
  };

  config = lib.mkIf config.Persistencia.enable {
    environment.persistence."/persist" = {
      enable = true;
      hideMounts = true;
      directories =
        [
          "/var/lib/nixos"
          "/etc/NetworkManager/system-connections"
        ]
        ++ config.Persistencia.extraDirectories;

      users.german = {
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
        files = [".p10k.zsh" ".zshrc"];
      };
    };
  };
}
