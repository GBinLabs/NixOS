{
  config,
  lib,
  pkgs,
  ...
}: {
  options.Reset.enable = lib.mkEnableOption "Reset PC";
  options.Reset-Netbook.enable = lib.mkEnableOption "Reset Netbook";
  options.Persistencia = {
    enable = lib.mkEnableOption "Habilitar Persistencia";
    extraSystemDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Directorios adicionales del sistema a persistir (rutas absolutas)";
    };

    extraUserDirectories = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "Directorios adicionales del usuario a persistir (rutas relativas al home)";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.Reset.enable {
      fileSystems = {
        "/home" = {
          neededForBoot = true;
        };
        "/persist" = {
          neededForBoot = true;
        };
      };

      boot.initrd.systemd = {
        enable = true;

        services = {
          "reset-root" = {
            description = "Resetear subvolumen root en SSD";
            wantedBy = ["initrd.target"];
            after = ["systemd-cryptsetup@p1.service"];
            before = ["sysroot.mount"];
            unitConfig.DefaultDependencies = "no";
            serviceConfig.Type = "oneshot";
            script = ''
              mkdir -p /mnt-root
              mount -o subvolid=5 /dev/mapper/p1 /mnt-root

              if [[ -e /mnt-root/root ]]; then
                # Eliminar subvolúmenes hijos recursivamente
                while IFS= read -r subvol; do
                  echo "Eliminando subvolumen hijo: $subvol"
                  btrfs subvolume delete "/mnt-root/$subvol" || true
                done < <(btrfs subvolume list -o /mnt-root/root | cut -f9- -d' ' | sort -r)

                # Eliminar el subvolumen root principal
                echo "Eliminando subvolumen root"
                btrfs subvolume delete /mnt-root/root || true
              fi

              # Crear nuevo subvolumen root
              echo "Creando nuevo subvolumen root"
              btrfs subvolume create /mnt-root/root

              umount /mnt-root
            '';
          };

          "reset-home" = {
            description = "Resetear subvolumen home en HDD";
            wantedBy = ["initrd.target"];
            after = ["systemd-cryptsetup@p2.service"];
            before = ["sysroot.mount"];
            unitConfig.DefaultDependencies = "no";
            serviceConfig.Type = "oneshot";
            script = ''
              mkdir -p /mnt-home
              mount -o subvolid=5 /dev/mapper/p2 /mnt-home

              if [[ -e /mnt-home/home ]]; then
                # Eliminar subvolúmenes hijos recursivamente
                while IFS= read -r subvol; do
                  echo "Eliminando subvolumen hijo: $subvol"
                  btrfs subvolume delete "/mnt-home/$subvol" || true
                done < <(btrfs subvolume list -o /mnt-home/home | cut -f9- -d' ' | sort -r)

                # Eliminar el subvolumen home principal
                echo "Eliminando subvolumen home"
                btrfs subvolume delete /mnt-home/home || true
              fi

              # Crear nuevo subvolumen home
              echo "Creando nuevo subvolumen home"
              btrfs subvolume create /mnt-home/home

              umount /mnt-home
            '';
          };
        };
      };

      systemd.services.setup-home = {
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
    })
    (lib.mkIf config.Reset-Netbook.enable {
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
    })
    (lib.mkIf config.Persistencia.enable {
    environment.persistence."/persist" = {
      enable = true;
      hideMounts = true;
      directories =
        [
          "/var/lib/nixos"
          "/etc/NetworkManager/system-connections"
        ]
        ++ config.Persistencia.extraSystemDirectories;

      users.german = {
        directories =
          [
            "Descargas"
            "Documentos"
            "Imágenes"
            "Música"
            "Vídeos"
            ".GitHub"
            ".ssh"
            ".config/sops"
            ".config/git"
            ".local/share/io.appflowy.appflowy"
          ]
          ++ config.Persistencia.extraUserDirectories;
        files = [".p10k.zsh" ".zshrc"];
      };
    };
  })
  ];
}
