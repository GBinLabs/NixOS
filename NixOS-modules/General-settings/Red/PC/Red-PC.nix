{
  config,
  lib,
  ...
}: {
  options = {
    Red-PC.enable = lib.mkEnableOption "Habilitar Red-PC";
  };

  config = lib.mkIf config.Red-PC.enable {
    networking = {
      hostName = "Bin-PC";
      networkmanager.enable = true;
    };
  };
}
