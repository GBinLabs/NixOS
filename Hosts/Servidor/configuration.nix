{ config, lib, pkgs, inputs,... }:

{

  imports = [ # Include the results of the hardware scan.
  	./hardware-configuration.nix
  	../../NixOS-modules/default-server.nix
	./disko.nix
  ];

  # Autoupgrade
  Autoupgrade-Notebook.enable = false;
  Autoupgrade-PC.enable = false;
  Autoupgrade-Servidor.enable = true;
  # Final Autoupgrade.
  
  # Bluetooth.
  Bluetooth.enable = true;
  # Final Bluetooth.
  
  # Drivers
  # CPU.
  CPU-AMD.enable = false;
  CPU-Intel.enable = true;

  # GPU.
  GPU-AMD = {
  	enable = false;
  	gaming.enable = false;
  };
  GPU-Intel.enable = true;
  GPU-Nvidia.enable = false;
  # Final Drivers.
  
  # Impermanence.
  Persistente-Notebook.enable = false;
  Persistente-PC.enable = false;
  Persistente-Servidor.enable = true;
  # Final Impermanence.
  
  # RED.
  Red-Notebook.enable = false;
  Red-PC.enable = false;
  Red-Servidor.enable = true;
  # Final RED.
  
  # Asegurarse que systemd monte correctamente los sistemas de archivos
  fileSystems = {
    "/persist".neededForBoot = true;
  };
  
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    mkdir /btrfs_tmp
    mount /dev/root_vg/root /btrfs_tmp
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
    fi

    delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }

    for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
    done

    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
  '';
  
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.german = {
	isNormalUser = true;
	description = "Germán N. González";
	extraGroups = [ "networkmanager" "wheel" ];
	hashedPasswordFile = config.sops.secrets.usuario-german.path;
  };
  
  environment.systemPackages = with pkgs; [
	gitFull
  ];

  
  ##################################### MINECRAFT ###############################################
  # Asumiendo que ya tienes nix-minecraft disponible como módulo/import
  services.minecraft-servers = {
    enable = true;
    eula = true; # Aceptamos EULA

    servers = {
      UnaAventura = {
        enable = true;

        # Seleccionamos el paquete PaperMC
        package = pkgs.paperServers.paper-1_21_4; # (ver nota abajo)

        serverProperties = {
          gamemode = 0; # 0 = Survival, 1 = Creative, 2 = Adventure, 3 = Spectator
          difficulty = "hard";
          simulation-distance = 10;
          level-seed = "4";
          hardcore = true; # Modo hardcore se activa aparte
          enable-rcon = false;
          motd = "¡Bienvenido a UnaAventura!";
        };

        #jvmOpts = "-Xms4000M -Xmx7000M -XX:UseG1GC";
        

        # Whitelist debe ser una lista o un objeto definido, o se puede omitir si no quieres whitelist
        #whitelist = {}; # Si no tienes jugadores todavía
      };
    };
  };

  # ¡DEJAR ASI!#
  system.stateVersion = "24.11";

}
