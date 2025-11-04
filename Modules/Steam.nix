# Modules/Steam.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  options.Steam.enable = lib.mkEnableOption "Habilitar Steam";

  config = lib.mkIf config.Steam.enable {
    programs = {
      steam = {
        enable = true;

        # Steam optimizations
        extraCompatPackages = with pkgs; [
          proton-ge-bin # Proton GE (mejor que vanilla)
        ];

        gamescopeSession.enable = true; # GameScope session

        # Variables de entorno para Steam
        package = pkgs.steam.override {
          extraEnv = {
            # AMD optimizations
            AMD_VULKAN_ICD = "RADV";
            RADV_PERFTEST = "nggc,sam,rt";

            # Mesa optimizations
            MESA_GLTHREAD = "true";
            mesa_glthread = "true";

            # Proton optimizations
            PROTON_ENABLE_NVAPI = "1";
            PROTON_HIDE_NVIDIA_GPU = "0";

            # Gamemode
            LD_PRELOAD = "${pkgs.gamemode}/lib/libgamemodeauto.so.0";
          };
        };
      };
    };

    boot.kernel.sysctl = {
      "net.ipv4.tcp_congestion_control" = "bbr";
      "net.core.default_qdisc" = "fq";
      "vm.dirty_ratio" = 10;
      "vm.dirty_background_ratio" = 5;
      "fs.file-max" = 2097152;
      "vm.max_map_count" = 2147483642;
    };

    programs.gamemode = {
      enable = true;
      settings.general = {
        renice = -10;
        ioprio = 0;
      };
    };

    security.pam.loginLimits = [
      {
        domain = "@users";
        item = "rtprio";
        value = "95";
      }
      {
        domain = "@users";
        item = "nice";
        value = "-10";
      }
    ];
  };
}
