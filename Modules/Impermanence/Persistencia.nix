{
  config,
  lib,
  ...
}: {
  options.Persistencia = {
    enable = lib.mkEnableOption "Habilitar Persistencia";
    extraSystemDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Directorios adicionales del sistema a persistir (rutas absolutas)";
    };

    extraUserDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Directorios adicionales del usuario a persistir (rutas relativas al home)";
    };
  };

  config = lib.mkIf config.Persistencia.enable {
    environment.persistence."/persist" = {
      enable = true;
      hideMounts = true;
      directories =
        [
          "/var/lib/nixos"
          "/var/cache"
          "/etc/NetworkManager/system-connections"
          "/root/.cache"
        ]
        ++ config.Persistencia.extraSystemDirectories;

      users.german = {
        directories =
          [
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
          ]
          ++ config.Persistencia.extraUserDirectories;
        files = [".p10k.zsh" ".zshrc"];
      };
    };
  };
}
