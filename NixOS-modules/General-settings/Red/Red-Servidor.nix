{
  config,
  lib,
  ...
}: {
  options = {
    Red-Servidor.enable = lib.mkEnableOption "Habilitar Red-Servidor";
  };

  config = lib.mkIf config.Red-Servidor.enable {
    networking = {
      hostName = "Servidor";
      networkmanager.enable = true;
    };
  };
}
