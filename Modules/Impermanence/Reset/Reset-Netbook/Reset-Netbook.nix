{
  config,
  lib,
  ...
}: {
  options = {
    Reset-Netbook.enable = lib.mkEnableOption "Habilitar Reset-Netbook";
  };

  config = lib.mkIf config.Reset-Netbook.enable {
    fileSystems = {
      "/persist" = {
        neededForBoot = true;
      };
    };

    boot.initrd.systemd = {
      enable = true;

      services = {
        "reset-root-netbook" = {
          description = "Resetear subvolumen root en Netbook";
          wantedBy = ["initrd.target"];
          after = ["systemd-cryptsetup@p1.service"];
          before = ["sysroot.mount"];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            mkdir -p /btrfs_tmp
            mount /dev/mapper/p1 /btrfs_tmp

            if [[ -e /btrfs_tmp/root ]]; then
              mkdir -p /btrfs_tmp/old_roots
              timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H:%M:%S")
              mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
            fi

            # Eliminar subvolúmenes antiguos (más de 30 días)
            for subvol_path in /btrfs_tmp/old_roots/*; do
              if [[ -d "$subvol_path" ]]; then
                age_days=$(( ($(date +%s) - $(stat -c %Y "$subvol_path")) / 86400 ))
                if [[ $age_days -gt 30 ]]; then
                  echo "Eliminando subvolumen antiguo: $subvol_path (''${age_days} días)"

                  # Eliminar subvolúmenes hijos recursivamente
                  while IFS= read -r child; do
                    btrfs subvolume delete "/btrfs_tmp/$child" || true
                  done < <(btrfs subvolume list -o "$subvol_path" | cut -f9- -d' ' | sort -r)

                  # Eliminar el subvolumen principal
                  btrfs subvolume delete "$subvol_path" || true
                fi
              fi
            done

            # Crear nuevo subvolumen root
            btrfs subvolume create /btrfs_tmp/root

            umount /btrfs_tmp
          '';
        };
      };
    };
  };
}
