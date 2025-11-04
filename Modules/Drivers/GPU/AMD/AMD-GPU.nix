# Modules/Drivers/GPU/AMD/AMD-GPU.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  options.GPU-AMD.enable = lib.mkEnableOption "GPU AMD - Máximo rendimiento gaming";

  config = lib.mkIf config.GPU-AMD.enable {
    hardware = {
      amdgpu = {
        opencl.enable = true;
        initrd.enable = true;
      };

      graphics = {
        enable = true;
        enable32Bit = true;

        extraPackages = with pkgs; [
          rocmPackages.clr.icd
          rocmPackages.clr
          libva
          libva-utils
        ];
      };
    };

    environment.sessionVariables = {
      AMD_VULKAN_ICD = "RADV";
      RADV_PERFTEST = "nggc,sam,rt,nir";
      MESA_GLTHREAD = "true";
      MESA_NO_ERROR = "1";
      MESA_DISK_CACHE_SIZE = "8192M";
      MESA_DISK_CACHE_SINGLE_FILE = "true";
      MESA_DISK_CACHE_DATABASE = "true";
      vblank_mode = "0";
      __GL_SYNC_TO_VBLANK = "0";
      WLR_DRM_NO_ATOMIC = "0";
      WLR_NO_HARDWARE_CURSORS = "1";
      WLR_RENDERER = "vulkan";
      MESA_VK_DEVICE_SELECT = "1002:7340";
      MESA_VK_DEVICE_SELECT_FORCE_DEFAULT_DEVICE = "1";
    };

    environment.systemPackages = with pkgs; [
      radeontop
      nvtopPackages.amd
      clinfo
      vulkan-tools
      libva-utils
      mesa-demos
      lact
    ];

    boot = {
      kernelModules = ["amdgpu"];

      kernelParams = [
        "amdgpu.dpm=1"
        "amdgpu.gpu_recovery=1"
        "amdgpu.audio=1"
        "amdgpu.dc=1"
        "amdgpu.ppfeaturemask=0xffffffff"
        "amdgpu.runpm=0"
        "amdgpu.gttsize=8192"
        "amdgpu.dpm_force_performance_level=high"
      ];

      initrd.kernelModules = ["amdgpu"];
    };

    systemd.tmpfiles.rules = [
      "w /sys/class/drm/card*/device/power_dpm_force_performance_level - - - - high"
      "w /sys/class/drm/card*/device/hwmon/hwmon*/pwm1_enable - - - - 1"
    ];

    services.lact.enable = true;

    services.udev.extraRules = ''
      KERNEL=="card[0-9]*", SUBSYSTEM=="drm", TAG+="uaccess"
      KERNEL=="hwmon*", SUBSYSTEM=="hwmon", ATTRS{name}=="amdgpu", MODE="0666"
    '';
  };
}
