{
  config,
  lib,
  ...
}: {
  options = {
    Reset-Netbook.enable = lib.mkEnableOption "Habilitar Reset-Netbook";
  };

  config = lib.mkIf config.Reset-Netbook.enable {
    # Asegurarse que systemd monte correctamente los sistemas de archivos
    fileSystems = {
      "/persist" = {
        neededForBoot = true;
      };
    };

    boot = {
      initrd = {
        postDeviceCommands = lib.mkAfter ''
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
      };
    };
  };
}
