{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    GPU-Nvidia.enable = lib.mkEnableOption "Habilitar GPU-Nvidia";
  };

  config = lib.mkIf config.GPU-Nvidia.enable {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [intel-media-driver intel-ocl intel-vaapi-driver];
      };
      nvidia = {
        package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
        nvidiaSettings = true;
        modesetting.enable = true;
        prime = {
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:4:0:0";
          offload.enable = true;
        };
      };
    };
  };

  #programs.atop.atopgpu.enable = true;
}
