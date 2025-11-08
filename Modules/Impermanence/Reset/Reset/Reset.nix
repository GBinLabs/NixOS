# Modules/Impermanence/Reset/Reset/Reset.nix
{config, lib, pkgs, ...}: {
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
  };
}
