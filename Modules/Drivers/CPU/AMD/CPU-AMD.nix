{
  config,
  lib,
  ...
}: {
  options = {
    CPU-AMD.enable = lib.mkEnableOption "Habilitar CPU-AMD";
  };

  config = lib.mkIf config.CPU-AMD.enable {
    hardware = {
      cpu = {
        amd = {
          updateMicrocode = true;
        };
      };
    };
  };
}
