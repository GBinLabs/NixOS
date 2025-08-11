{pkgs, lib, ...}: {

  # Window-Manager Hyprland + SDDM.
  
  ## Hyprland.
  programs = {
  	hyprland = {
    		enable = true;
    		withUWSM = true;
    		xwayland = {
    			enable = true;
    		};
    		portalPackage = pkgs.xdg-desktop-portal-hyprland;
    		package = pkgs.hyprland;
  	};
  	uwsm = {
    		enable = true;
    		package = pkgs.uwsm;
    		waylandCompositors = {
      			hyprland = {
        			prettyName = "Hyprland";
        			#comment = "Hyprland compositor manager by UWSM";
        			binPath = "/run/current-system/sw/bin/Hyprland";
      			};
    		};
  	};
  };
  ## Final Hyprland.
  
  ## SDDM.
  services = {
  	displayManager = {
    		sddm = {
      			enable = true;
      			wayland = {
      				enable = true;
      			};
      			theme = "sddm-astronaut-theme";
      			package = pkgs.kdePackages.sddm;
      			extraPackages = with pkgs; [
        			sddm-astronaut
      			];
    		};
    	defaultSession = "hyprland-uwsm";
  	};
  };
  ## Final SDDM.
  
  ## Fonts.
  fonts = {
  	packages = with pkgs; [
    		nerd-fonts.jetbrains-mono
  	];
  };
  ## Final Fonts
  
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
    kernelPackages = pkgs.linuxPackages_zen;
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
          "steam"
          "steam-original"
          "steam-unwrapped"
          "steam-run"
          "intel-ocl"
          "discord"
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
    
    ## USB + Trashcan 1.
    gvfs.enable = true;
    udisks2.enable = true;
    ## Final USB + Trashcan 1.
  };
  
  ## Pipewire 2.
  security = {
    rtkit = {
      enable = true;
    };
  };
  ## Final Pipewire 2.
  
  ## USB + Trashcan 2.
  environment.systemPackages = with pkgs; [
    usbutils
    udiskie
    udisks
  ];
  ## Final USB + Trashcan 2.
  
  # Final services
  
  programs = {
    java = {
      enable = true;
      package = pkgs.jdk24;
    };
    nm-applet = {
    	enable = true;
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
