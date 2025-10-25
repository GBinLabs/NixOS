{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    GPU-Intel = {
      enable = lib.mkEnableOption "Habilitar GPU-Intel optimizada";
      
      # Opción para seleccionar el driver VA-API preferido
      vaDriver = lib.mkOption {
        type = lib.types.enum [ "iHD" "i965" "auto" ];
        default = "auto";
        description = ''
          Driver VA-API a utilizar:
          - "iHD": intel-media-driver (Gen 8+, recomendado para Gemini Lake)
          - "i965": intel-vaapi-driver (Gen 7 y anteriores, recomendado para Ivy Bridge)
          - "auto": Detecta automáticamente según la GPU
        '';
      };
      
      # Habilitar optimizaciones agresivas (desactivar si hay problemas)
      enableOptimizations = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Habilitar parámetros de optimización del kernel i915";
      };
    };
  };

  config = lib.mkIf config.GPU-Intel.enable {
    # ===== Hardware Graphics =====
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        
        extraPackages = with pkgs; [
          # Drivers VA-API (ambos para máxima compatibilidad)
          intel-media-driver   # iHD - Gen 8+ (Broadwell onwards)
          intel-vaapi-driver   # i965 - Gen 3-9.5 (hasta Kaby Lake)
          
          # Vulkan y OpenCL
          intel-compute-runtime  # OpenCL Gen 8+
          
          # Librerías adicionales
          vaapiIntel           # Wrapper VA-API
          vaapiVdpau           # Backend VDPAU
          libvdpau-va-gl       # VDPAU sobre VA-API
        ];
        
        extraPackages32 = with pkgs.pkgsi686Linux; [
          intel-media-driver
          intel-vaapi-driver
          vaapiIntel
        ];
      };

      # Herramientas de diagnóstico
      intel-gpu-tools.enable = true;
    };

    # ===== Variables de entorno =====
    environment = {
      sessionVariables = lib.mkMerge [
        # Configuración base
        {
          # Forzar renderizado por hardware en Firefox/Chromium
          MOZ_ENABLE_WAYLAND = "1";
          
          # Habilitar aceleración de video en Chromium
          NIXOS_OZONE_WL = "1";
        }
        
        # Driver VA-API según configuración
        (lib.mkIf (config.GPU-Intel.vaDriver == "iHD") {
          LIBVA_DRIVER_NAME = "iHD";
        })
        (lib.mkIf (config.GPU-Intel.vaDriver == "i965") {
          LIBVA_DRIVER_NAME = "i965";
        })
        # Si es "auto", no setear la variable (deja que el sistema elija)
      ];

      # Paquetes útiles para diagnóstico
      systemPackages = with pkgs; [
        libva-utils      # vainfo, vdpauinfo
        vulkan-tools     # vulkaninfo
        mesa-demos       # glxinfo, glxgears
        clinfo           # Info de OpenCL (si aplica)
      ];
    };

    # ===== Módulos del kernel =====
    boot = {
      kernelModules = [ "i915" ];
      
      # Parámetros optimizados (compatibles con ambas GPUs)
      kernelParams = lib.mkMerge [
        # Parámetros básicos (siempre activos)
        [ "i915.fastboot=1" ]
        
        # Optimizaciones opcionales
        (lib.mkIf config.GPU-Intel.enableOptimizations [
          "i915.enable_fbc=1"      # Framebuffer compression (Gen 4+)
          "i915.enable_psr=0"      # PSR: 0 para Ivy Bridge, 1 para Gemini Lake
          # Nota: PSR puede causar problemas en GPUs antiguas
        ])
      ];
      
      # Cargar módulos temprano para arranque suave
      initrd.kernelModules = [ "i915" ];
    };
  };
}
