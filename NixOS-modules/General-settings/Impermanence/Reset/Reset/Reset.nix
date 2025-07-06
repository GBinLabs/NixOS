{lib, ...}: {
  # Asegurarse que systemd monte correctamente los sistemas de archivos
  fileSystems = {
    "/home".neededForBoot = true;
    "/persist".neededForBoot = true;
  };

  boot.initrd.postDeviceCommands = lib.mkAfter ''
    # Mejora en el script de borrado de subvolúmenes

    # Configuración de depuración
    set -x  # Habilitar el modo de depuración

    # Función mejorada para listar subvolúmenes
    list_subvolumes() {
      local mount_point="$1"
      btrfs subvolume list "$mount_point" | sed 's/^ID [0-9]* gen [0-9]* top level [0-9]* path //g'
    }

    # Función mejorada para eliminar subvolúmenes de forma recursiva
    delete_subvolumes() {
      local mount_point="$1"
      local target_subvol="$2"

      # Verificar que el punto de montaje existe
      if [ ! -d "$mount_point" ]; then
        echo "ERROR: Punto de montaje $mount_point no existe"
        return 1
      fi

      # Verificar que está montado
      if ! mountpoint -q "$mount_point"; then
        echo "ERROR: $mount_point no está montado"
        return 1
      fi

      # Listar todos los subvolúmenes
      echo "Listando subvolúmenes en $mount_point:"
      list_subvolumes "$mount_point"

      # Verificar si el subvolumen objetivo existe
      if ! btrfs subvolume list "$mount_point" | grep -q " path $target_subvol$"; then
        echo "AVISO: El subvolumen $target_subvol no existe en $mount_point"
        return 0
      fi

      # Encontrar subvolúmenes hijos primero (ordenados por profundidad)
      local child_subvols=$(btrfs subvolume list -o "$mount_point/$target_subvol" | sed 's/^ID [0-9]* gen [0-9]* top level [0-9]* path //g' | sort -r)

      # Eliminar subvolúmenes hijos recursivamente
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

      # Eliminar el subvolumen objetivo
      echo "Eliminando subvolumen objetivo: $target_subvol"
      btrfs subvolume delete "$mount_point/$target_subvol" || echo "ERROR: No se pudo eliminar $target_subvol"
    }

    # Restaurar /root desde el SSD
    echo "=== Procesando disco SSD (/dev/mapper/p1) ==="
    mkdir -p /mnt-root
    mount -o subvolid=5 /dev/mapper/p1 /mnt-root || { echo "ERROR: No se pudo montar /dev/mapper/p1"; exit 1; }

    # Eliminar subvolumen root
    delete_subvolumes "/mnt-root" "root"

    # Crear nuevo subvolumen root
    echo "Creando nuevo subvolumen root"
    btrfs subvolume create /mnt-root/root || echo "ERROR: No se pudo crear subvolumen root"

    # Desmontar
    umount /mnt-root

    # Restaurar /home desde el HDD
    echo "=== Procesando disco HDD (/dev/mapper/p2) ==="
    mkdir -p /mnt-home
    mount -o subvolid=5 /dev/mapper/p2 /mnt-home || { echo "ERROR: No se pudo montar /dev/mapper/p2"; exit 1; }

    # Eliminar subvolumen home
    delete_subvolumes "/mnt-home" "home"

    # Crear nuevo subvolumen home
    echo "Creando nuevo subvolumen home"
    btrfs subvolume create /mnt-home/home || echo "ERROR: No se pudo crear subvolumen home"

    # Desmontar
    umount /mnt-home

    # Deshabilitar el modo de depuración
    set +x

    echo "=== Proceso de regeneración de subvolúmenes completado ==="
  '';
  
  # Configuración para copiar skel a /home durante el arranque
  systemd.services.setup-home = {
    description = "Configurar el directorio /home después del arranque";
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "setup-home" ''
        # Crear usuarios si no existen
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
}
