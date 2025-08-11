{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    GPU-Intel.enable = lib.mkEnableOption "Habilitar GPU-Intel";
  };

  config = lib.mkIf config.GPU-Intel.enable {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [intel-media-driver intel-ocl intel-vaapi-driver];
      };
      intel-gpu-tools = {
        enable = true;
      };
    };
  };
}
