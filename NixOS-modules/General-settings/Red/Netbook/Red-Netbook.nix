{
  config,
  lib,
  ...
}: {
  options = {
    Red-Netbook.enable = lib.mkEnableOption "Habilitar Red-Netbook";
  };

  config = lib.mkIf config.Red-Netbook.enable {
    networking = {
      hostName = "Bin-Netbook";
      networkmanager = {
        enable = true;
      };
    };
  };
}
