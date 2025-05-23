{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    GPU-AMD.enable = lib.mkEnableOption "Habilitar GPU-AMD";
  };

  config = lib.mkIf config.GPU-Intel.enable {
  	hardware = {
  		amdgpu = {
  			opencl = {
  				enable = true;
  			};
  			initrd = {
  				enable = true;
  			};
  		};
  		graphics = {
  			enable = true;
  			enable32Bit = true;
  			package = pkgs.mesa;
  			package32 = pkgs.pkgsi686Linux.mesa;
  		};
  	};
  };
}
