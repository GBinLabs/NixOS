{
  config,
  lib,
  ...
}: {
  options = {
    Persistente-Servidor.enable = lib.mkEnableOption "Habilitar Persistencia-Servidor";
  };

  config = lib.mkIf config.Persistente-Servidor.enable {
    fileSystems."/persist".neededForBoot = true;

    environment.persistence."/persist" = {
      enable = true;
      hideMounts = true;
      directories = [
        "/var/lib/minecraft"
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
          ".config/sops"
        ];
      };
    };
  };
}
