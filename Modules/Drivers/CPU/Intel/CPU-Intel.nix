{
  config,
  lib,
  ...
}: {
  options = {
    CPU-Intel.enable = lib.mkEnableOption "Habilitar CPU-Intel";
  };

  config = lib.mkIf config.CPU-Intel.enable {
    hardware = {
      cpu = {
        intel = {
          updateMicrocode = true;
        };
      };
    };

    services = {
      throttled = {
        enable = true;
      };
    };
  };
}
