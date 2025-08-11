{
  pkgs,
  lib,
  ...
}: {
  # Desktop-Manager Gnome + GDM.

  ## Gnome.
  services = {
    desktopManager = {
      gnome = {
        enable = true;
      };
    };
    gnome = {
      core-apps = {
        enable = false;
      };
      localsearch = {
        enable = false;
      };
      tinysparql = {
        enable = false;
      };
    };
  };

  hardware = {
    bluetooth = {
      powerOnBoot = false;
    };
  };

  environment = {
    gnome = {
      excludePackages = [pkgs.gnome-tour];
    };
  };
  ## Final Gnome.

  ## GDM.
  services = {
    displayManager = {
      gdm = {
        enable = true;
        wayland = true;
        banner = ''¡Hola!'';
        autoSuspend = true;
        debug = false;
      };
      defaultSession = "gnome";
    };
  };
  ## Final GDM.

  # Final Window-Manager Hyprland + SDDM.

  # Boot.

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };

  # Final Boot

  # Nix.

  ## Flakes.
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };
  ## Final Flakes.

  ## Propietary Software.
  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "intel-ocl"
        ];
    };
  };
  ## Final Propietary Software.

  # Final Nix.

  # Services.

  services = {
    ## Fwupd.
    fwupd = {
      enable = true;
    };
    ## Final Fwupd.

    ## DNS.
    resolved = {
      enable = true;
      extraConfig = ''
        [Resolve]
        DNS=193.110.81.0#dns0.eu
        DNS=2a0f:fc80::#dns0.eu
        DNS=185.253.5.0#dns0.eu
        DNS=2a0f:fc81::#dns0.eu
        DNSOverTLS=yes
      '';
    };
    ## Final DNS.

    ## Mouse-DPI.
    ratbagd = {
      enable = true;
      package = pkgs.libratbag;
    };
    ## Final Mouse-DPI.

    ## Pipewire 1.
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse = {
        enable = true;
      };
      jack = {
        enable = true;
      };
      wireplumber = {
        enable = true;
        package = pkgs.wireplumber;
      };
    };
    ## Final Pipewire 1.
  };

  ## Pipewire 2.
  security = {
    rtkit = {
      enable = true;
    };
  };
  ## Final Pipewire 2.

  # Final services

  programs = {
    java = {
      enable = true;
      package = pkgs.jdk24;
    };
  };

  # Keyboard + Timezone.

  i18n = {
    defaultLocale = "es_AR.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "es_AR.UTF-8";
      LC_IDENTIFICATION = "es_AR.UTF-8";
      LC_MEASUREMENT = "es_AR.UTF-8";
      LC_MONETARY = "es_AR.UTF-8";
      LC_NAME = "es_AR.UTF-8";
      LC_NUMERIC = "es_AR.UTF-8";
      LC_PAPER = "es_AR.UTF-8";
      LC_TELEPHONE = "es_AR.UTF-8";
      LC_TIME = "es_AR.UTF-8";
    };
  };

  console = {
    keyMap = "la-latin1";
  };

  time = {
    timeZone = "America/Argentina/Tucuman";
  };

  # Final Keyboard + Timezone.

  # Systemd.

  systemd = {
    user = {
      services = {
        set-microphone-volume = {
          description = "Establecer volumen del micrófono al 30%";
          wantedBy = ["pipewire.service"];
          after = ["pipewire.service" "wireplumber.service"];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SOURCE@ 0.3";
            ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
          };
        };
      };
    };
  };

  # Final Systemd.
}
