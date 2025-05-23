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
          nvidiaBusId = "PCI:4:0:0";
          sync.enable = true;
        };
      };
    };
  };

  #programs.atop.atopgpu.enable = true;
}
