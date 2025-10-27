{
  config,
  pkgs,
  lib,
  ...
}: {
  options = {
    GPU-Nvidia = {
      enable = lib.mkEnableOption "Habilitar GPU-Nvidia híbrida";
      
      # Modo PRIME (importante para laptops)
      primeMode = lib.mkOption {
        type = lib.types.enum [ "offload" "sync" "reverseSync" ];
        default = "offload";
        description = ''
          Modo de operación PRIME:
          - "offload": NVIDIA on-demand, Intel por defecto (ahorra batería)
          - "sync": NVIDIA siempre activa (máximo rendimiento, más consumo)
          - "reverseSync": NVIDIA como GPU principal, Intel para display
        '';
      };
      
      # IDs de bus PCI (ajustar según tu sistema)
      intelBusId = lib.mkOption {
        type = lib.types.str;
        default = "PCI:0:2:0";
        description = "Bus ID de la GPU Intel (ver con: lspci | grep VGA)";
      };
      
      nvidiaBusId = lib.mkOption {
        type = lib.types.str;
        default = "PCI:4:0:0";
        description = "Bus ID de la GPU NVIDIA (ver con: lspci | grep NVIDIA)";
      };
      
      # Habilitar herramientas de gestión
      enableUtils = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Instalar herramientas de diagnóstico y gestión";
      };
    };
  };

  config = lib.mkIf config.GPU-Nvidia.enable {
    # ===== Hardware Graphics =====
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        
        # Drivers Intel (para iGPU)
        extraPackages = with pkgs; [
          intel-media-driver   # iHD - VA-API
          intel-vaapi-driver   # i965 - VA-API legacy
          vaapiVdpau           # VDPAU backend
          libvdpau-va-gl       # VDPAU sobre VA-API
        ];
        
        extraPackages32 = with pkgs.pkgsi686Linux; [
          intel-media-driver
          intel-vaapi-driver
          libva
          libvdpau
        ];
      };

      # ===== Configuración NVIDIA =====
      nvidia = {
        # Driver legacy 470 (último que soporta 820M Kepler)
        package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
        
        # Habilitar configuración gráfica (nvidia-settings)
        nvidiaSettings = true;
        
        # Modesetting esencial para Wayland y mejor compatibilidad
        modesetting.enable = true;
        
        # Gestión de energía (importante para laptops)
        powerManagement = {
          enable = true;
          # Fine-grained power management (suspender GPU cuando no se usa)
          finegrained = (config.GPU-Nvidia.primeMode == "offload");
        };
        
        # ===== PRIME Configuration =====
        prime = {
          # Bus IDs (ajustar según tu hardware)
          intelBusId = config.GPU-Nvidia.intelBusId;
          nvidiaBusId = config.GPU-Nvidia.nvidiaBusId;
          
          # Offload mode (recomendado para laptops - NVIDIA on-demand)
          offload = {
            enable = (config.GPU-Nvidia.primeMode == "offload");
            enableOffloadCmd = (config.GPU-Nvidia.primeMode == "offload");
          };
          
          # Sync mode (NVIDIA siempre activa)
          sync.enable = (config.GPU-Nvidia.primeMode == "sync");
          
          # Reverse Sync (NVIDIA como principal)
          reverseSync.enable = (config.GPU-Nvidia.primeMode == "reverseSync");
        };
        
        # Abrir módulo NVIDIA (permite modificar configuraciones)
        open = false;  # La 820M no soporta el driver open-source
      };
    };

    # ===== Variables de entorno =====
    environment = {
      sessionVariables = lib.mkMerge [
        # Variables base
        {
          # Usar iHD para Intel VA-API
          LIBVA_DRIVER_NAME = "i965";  # Usa i965 si tu Intel es antigua
          
          # Wayland
          WLR_DRM_NO_ATOMIC = "1";  # Necesario para NVIDIA en Wayland
          GBM_BACKEND = "nvidia-drm";
          __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        }
        
        # Variables para PRIME Offload
        (lib.mkIf (config.GPU-Nvidia.primeMode == "offload") {
          # Estas permiten usar: nvidia-offload <comando>
          # Ejemplo: nvidia-offload glxgears
        })
      ];

      # Paquetes del sistema
      systemPackages = with pkgs; [
        # Herramientas básicas
        (lib.mkIf config.GPU-Nvidia.enableUtils glxinfo)
        (lib.mkIf config.GPU-Nvidia.enableUtils vulkan-tools)
        (lib.mkIf config.GPU-Nvidia.enableUtils libva-utils)
        
        # Script para ejecutar aplicaciones en NVIDIA (modo offload)
        (lib.mkIf (config.GPU-Nvidia.primeMode == "offload") (
          pkgs.writeShellScriptBin "nvidia-offload" ''
            export __NV_PRIME_RENDER_OFFLOAD=1
            export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
            export __GLX_VENDOR_LIBRARY_NAME=nvidia
            export __VK_LAYER_NV_optimus=NVIDIA_only
            exec "$@"
          ''
        ))
        
        # Herramienta de monitoreo NVIDIA
        (lib.mkIf config.GPU-Nvidia.enableUtils nvtopPackages.nvidia)
      ];
    };

    # ===== Módulos del kernel =====
    boot = {
      # Módulos necesarios
      kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
      
      # Parámetros del kernel
      kernelParams = [
        # Modesetting para NVIDIA
        "nvidia-drm.modeset=1"
        
        # Desactivar logo de NVIDIA en boot
        "nvidia-drm.fbdev=1"
      ];
      
      # Blacklist nouveau (driver open-source que conflictúa)
      blacklistedKernelModules = [ "nouveau" ];
      
      # Cargar módulos temprano
      initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    };

    # ===== Servicios =====
    services = {
      # Xorg configuration (si no usas Wayland puro)
      xserver = {
        videoDrivers = [ "nvidia" ];
        
        # Configuración específica para laptops híbridas
        screenSection = ''
          Option "metamodes" "nvidia-auto-select +0+0 {ForceCompositionPipeline=On, ForceFullCompositionPipeline=On}"
          Option "AllowIndirectGLXProtocol" "off"
          Option "TripleBuffer" "on"
        '';
      };
    };

    # ===== Reglas udev para gestión de energía =====
    services.udev.extraRules = lib.mkIf (config.GPU-Nvidia.primeMode == "offload") ''
      # Permitir runtime PM en GPU NVIDIA cuando no está en uso
      ACTION=="add", SUBSYSTEM=="pci", ATTR{vendor}=="0x10de", ATTR{class}=="0x030000", TEST=="power/control", ATTR{power/control}="auto"
    '';
  };
}
