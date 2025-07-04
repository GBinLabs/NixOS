{ config, pkgs, ... }:

{

  imports = [
  	./hardware-configuration.nix
  	../../NixOS-modules/default.nix
	./disko.nix
  ];
  
  # Drivers
  # CPU.
  CPU-AMD.enable = false;
  CPU-Intel.enable = true;

  # GPU.
  GPU-AMD.enable = false;
  GPU-Intel.enable = true;
  GPU-Nvidia.enable = false;
  # Final Drivers.
  
  # Impermanence.
  Persistente-Netbook.enable = true;
  Persistente-Notebook.enable = false;
  Persistente-PC.enable = false;
  # Final Impermanence.
  
  # Juegos.
  Steam.enable = false;
  Gamemode.enable = false;
  # Final Juegos.
  
  # RED.
  Red-Netbook.enable = true;
  Red-Notebook.enable = false;
  Red-PC.enable = false;
  # Final RED.
  
  # Asegurarse que systemd monte correctamente los sistemas de archivos
  fileSystems = {
    "/persist".neededForBoot = true;
  };
  
  boot.initrd.postDeviceCommands = lib.mkAfter ''
  mkdir /btrfs_tmp
  mount /dev/mapper/p1 /btrfs_tmp
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
  users.mutableUsers = false;
  users.users.german = {
	isNormalUser = true;
	description = "Germán N. González";
	extraGroups = [ "networkmanager" "wheel" "audio" ];
	hashedPasswordFile = config.sops.secrets.usuario-german.path;
  };

  # ¡DEJAR ASI!#
  system.stateVersion = "24.11";

}
