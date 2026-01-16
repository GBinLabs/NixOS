{
  config,
  lib,
  pkgs,
  ...
}:
{
  options = {
    Reset.enable = lib.mkEnableOption "Reset PC (dos discos)";
    Reset-Netbook.enable = lib.mkEnableOption "Reset Netbook (un disco)";
    Persistencia = {
      enable = lib.mkEnableOption "Habilitar Persistencia";
      extraSystemDirectories = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Directorios adicionales del sistema a persistir";
      };
      extraUserDirectories = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
        description = "Directorios adicionales del usuario a persistir";
      };
    };
  };

  config = lib.mkMerge [
    # Reset para PC (SSD + HDD separados)
    (lib.mkIf config.Reset.enable {
      fileSystems = {
        "/home".neededForBoot = true;
        "/persist".neededForBoot = true;
      };

      boot.initrd.systemd.services = {
        reset-root = {
          description = "Resetear subvolumen root en SSD";
          wantedBy = [ "initrd.target" ];
          after = [ "systemd-cryptsetup@p1.service" ];
          before = [ "sysroot.mount" ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            mkdir -p /mnt-root
            mount -o subvolid=5 /dev/mapper/p1 /mnt-root

            if [[ -e /mnt-root/root ]]; then
              btrfs subvolume list -o /mnt-root/root | cut -f9- -d' ' | sort -r | \
                while read -r subvol; do
                  btrfs subvolume delete "/mnt-root/$subvol" || true
                done
              btrfs subvolume delete /mnt-root/root || true
            fi

            btrfs subvolume create /mnt-root/root
            umount /mnt-root
          '';
        };

        reset-home = {
          description = "Resetear subvolumen home en HDD";
          wantedBy = [ "initrd.target" ];
          after = [ "systemd-cryptsetup@p2.service" ];
          before = [ "sysroot.mount" ];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            mkdir -p /mnt-home
            mount -o subvolid=5 /dev/mapper/p2 /mnt-home

            if [[ -e /mnt-home/home ]]; then
              btrfs subvolume list -o /mnt-home/home | cut -f9- -d' ' | sort -r | \
                while read -r subvol; do
                  btrfs subvolume delete "/mnt-home/$subvol" || true
                done
              btrfs subvolume delete /mnt-home/home || true
            fi

            btrfs subvolume create /mnt-home/home
            umount /mnt-home
          '';
        };
      };

      systemd.services.setup-home = {
        description = "Configurar /home después del arranque";
        wantedBy = [ "multi-user.target" ];
        after = [ "local-fs.target" ];
        before = [ "display-manager.service" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = pkgs.writeShellScript "setup-home" ''
            for user in /persist/home/*; do
              [ -d "$user" ] || continue
              username=$(basename "$user")
              if [ ! -d "/home/$username" ]; then
                mkdir -p "/home/$username"
                cp -a /etc/skel/. "/home/$username/"
                chown -R "$username:users" "/home/$username"
                chmod 750 "/home/$username"
              fi
            done
          '';
        };
      };
    })

    # Reset para Netbook (un solo disco)
    (lib.mkIf config.Reset-Netbook.enable {
      fileSystems."/persist".neededForBoot = true;

      boot.initrd.systemd.services.reset-root-netbook = {
        description = "Resetear subvolumen root en Netbook";
        wantedBy = [ "initrd.target" ];
        after = [ "systemd-cryptsetup@p1.service" ];
        before = [ "sysroot.mount" ];
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

          # Limpiar snapshots antiguos (>30 días)
          for subvol_path in /btrfs_tmp/old_roots/*; do
            [[ -d "$subvol_path" ]] || continue
            age_days=$(( ($(date +%s) - $(stat -c %Y "$subvol_path")) / 86400 ))
            if [[ $age_days -gt 30 ]]; then
              btrfs subvolume list -o "$subvol_path" | cut -f9- -d' ' | sort -r | \
                while read -r child; do
                  btrfs subvolume delete "/btrfs_tmp/$child" || true
                done
              btrfs subvolume delete "$subvol_path" || true
            fi
          done

          btrfs subvolume create /btrfs_tmp/root
          umount /btrfs_tmp
        '';
      };
    })

    # Persistencia común
    (lib.mkIf config.Persistencia.enable {
      environment.persistence."/persist" = {
        enable = true;
        hideMounts = true;
        directories = [
          "/var/lib/nixos"
          "/etc/NetworkManager/system-connections"
          "/var/lib/AccountsService"
        ]
        ++ config.Persistencia.extraSystemDirectories;

        users.german = {
          directories = [
            "Descargas"
            "Documentos"
            "Imágenes"
            "Música"
            "Vídeos"
            ".GitHub"
            ".ssh"
            ".config/sops"
            ".config/git"
            ".config/obsidian"
          ]
          ++ config.Persistencia.extraUserDirectories;
          files = [
            ".p10k.zsh"
            ".zshrc"
          ];
        };
      };
    })
  ];
}
