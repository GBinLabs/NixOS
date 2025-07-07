{
  config,
  lib,
  pkgs,
  ...
}: {
  options = {
    Reset.enable = lib.mkEnableOption "Habilitar Reset";
  };

  config = lib.mkIf config.Reset.enable {
    fileSystems = {
      "/home" = {
        neededForBoot = true;
      };
      "/persist" = {
        neededForBoot = true;
      };
    };

    boot = {
      initrd = {
        postDeviceCommands = lib.mkAfter ''
          set -x

          list_subvolumes() {
            local mount_point="$1"
            btrfs subvolume list "$mount_point" | sed 's/^ID [0-9]* gen [0-9]* top level [0-9]* path //g'
          }

          delete_subvolumes() {
            local mount_point="$1"
            local target_subvol="$2"

            if [ ! -d "$mount_point" ]; then
              echo "ERROR: Punto de montaje $mount_point no existe"
              return 1
            fi

            if ! mountpoint -q "$mount_point"; then
              echo "ERROR: $mount_point no está montado"
              return 1
            fi

            echo "Listando subvolúmenes en $mount_point:"
            list_subvolumes "$mount_point"

            if ! btrfs subvolume list "$mount_point" | grep -q " path $target_subvol$"; then
              echo "AVISO: El subvolumen $target_subvol no existe en $mount_point"
              return 0
            fi

            local child_subvols=$(btrfs subvolume list -o "$mount_point/$target_subvol" | sed 's/^ID [0-9]* gen [0-9]* top level [0-9]* path //g' | sort -r)

            if [ -n "$child_subvols" ]; then
              echo "Subvolúmenes hijos encontrados para $target_subvol:"
              echo "$child_subvols"

              for subvol in $child_subvols; do
                echo "Eliminando subvolumen hijo: $subvol"
                btrfs subvolume delete "$mount_point/$subvol" || echo "ERROR: No se pudo eliminar $subvol"
              done
            else
              echo "No se encontraron subvolúmenes hijos para $target_subvol"
            fi

            echo "Eliminando subvolumen objetivo: $target_subvol"
            btrfs subvolume delete "$mount_point/$target_subvol" || echo "ERROR: No se pudo eliminar $target_subvol"
          }

          echo "=== Procesando disco SSD (/dev/mapper/p1) ==="
          mkdir -p /mnt-root
          mount -o subvolid=5 /dev/mapper/p1 /mnt-root || { echo "ERROR: No se pudo montar /dev/mapper/p1"; exit 1; }

          delete_subvolumes "/mnt-root" "root"

          echo "Creando nuevo subvolumen root"
          btrfs subvolume create /mnt-root/root || echo "ERROR: No se pudo crear subvolumen root"

          umount /mnt-root

          echo "=== Procesando disco HDD (/dev/mapper/p2) ==="
          mkdir -p /mnt-home
          mount -o subvolid=5 /dev/mapper/p2 /mnt-home || { echo "ERROR: No se pudo montar /dev/mapper/p2"; exit 1; }

          delete_subvolumes "/mnt-home" "home"

          echo "Creando nuevo subvolumen home"
          btrfs subvolume create /mnt-home/home || echo "ERROR: No se pudo crear subvolumen home"

          umount /mnt-home

          set +x

          echo "=== Proceso de regeneración de subvolúmenes completado ==="
        '';
      };
    };

    systemd = {
      services = {
        setup-home = {
          description = "Configurar el directorio /home después del arranque";
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = pkgs.writeShellScript "setup-home" ''
              for user in /persist/home/*; do
                if [ -d "$user" ]; then
                  username=$(basename "$user")
                  if [ ! -d "/home/$username" ]; then
                    echo "Configurando /home para el usuario $username"
                    mkdir -p "/home/$username"
                    cp -a /etc/skel/. "/home/$username/"
                    chown -R "$username:users" "/home/$username"
                    chmod 750 "/home/$username"
                  fi
                fi
              done
            '';
          };
          after = ["local-fs.target"];
          before = ["display-manager.service"];
        };
      };
    };
  };
}
