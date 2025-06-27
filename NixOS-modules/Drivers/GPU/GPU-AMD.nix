{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    GPU-AMD.enable = lib.mkEnableOption "Habilitar GPU-AMD";
  };

  config = lib.mkIf config.GPU-AMD.enable {
  	hardware = {
      		amdgpu = {
        		opencl.enable = true;
        		initrd.enable = true;
        		# SOLO USAR RADV - Eliminar AMDVLK para máximo rendimiento
        		amdvlk.enable = false;  # DESHABILITADO para evitar conflictos
      		};
      
      		graphics = {
        		enable = true;
        		enable32Bit = true;
        		package = pkgs.mesa;
        		package32 = pkgs.pkgsi686Linux.mesa;
        
        		# Configuración específica para máximo rendimiento
        		extraPackages = with pkgs; [
          			rocmPackages.clr.icd
        		];
      		};
    	};
  };
}
