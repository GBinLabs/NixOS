{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    GPU-AMD = {
      enable = lib.mkEnableOption "Habilitar GPU-AMD";
      opencl.enable = lib.mkEnableOption "Habilitar soporte OpenCL" // {default = true;};
      gaming.enable = lib.mkEnableOption "Habilitar optimizaciones para juegos" // {default = false;};
    };
  };

  config = lib.mkIf config.GPU-AMD.enable {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs;
          [
            # Base packages
            amdvlk
          ]
          ++ lib.optionals config.GPU-AMD.opencl.enable [
            rocmPackages.clr.icd
          ];
        extraPackages32 = with pkgs.pkgsi686Linux; [
          amdvlk
        ];
      };
      amdgpu = {
        amdvlk = {
          enable = true;
          package = pkgs.amdvlk;
          settings = lib.optionalAttrs config.GPU-AMD.gaming.enable {
            # Gaming-optimized settings
            "ReBar" = "1";
            "PreferSoftwareRendering" = "0";
            "EnableIommu" = "1";
          };
          supportExperimental.enable = true;
          support32Bit.enable = true;
        };
        legacySupport.enable = true;
        opencl.enable = config.GPU-AMD.opencl.enable;
      };
    };

    # Add gaming-specific optimizations conditionally
    boot.kernelParams = lib.optionals config.GPU-AMD.gaming.enable [
      "amdgpu.ppfeaturemask=0xffffffff"
      "amdgpu.dc=1"
      "amdgpu.dpm=1"
    ];
  };
}
