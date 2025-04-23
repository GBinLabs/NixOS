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
      cpu.intel.updateMicrocode = true;
      nvidia.prime.intelBusId = "PCI:0:2:0";
    };

    services.throttled.enable = true;
  };
}
