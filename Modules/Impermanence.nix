{
  config,
  lib,
  pkgs,
  ...
}:
let
  mkResetService = device: subvolume: {
    wantedBy = [ "initrd.target" ];
    after = [ "systemd-cryptsetup@${device}.service" ];
    before = [ "sysroot.mount" ];
    unitConfig.DefaultDependencies = "no";
    serviceConfig.Type = "oneshot";
    script = ''
      mkdir -p /mnt-reset
      mount -o subvolid=5 /dev/mapper/${device} /mnt-reset
      if [[ -e /mnt-reset/${subvolume} ]]; then
        btrfs subvolume list -o /mnt-reset/${subvolume} | cut -f9- -d' ' | sort -r | \
          while read -r sv; do btrfs subvolume delete "/mnt-reset/$sv" || true; done
        btrfs subvolume delete /mnt-reset/${subvolume} || true
      fi
      btrfs subvolume create /mnt-reset/${subvolume}
      umount /mnt-reset
    '';
  };
in
{
  options = {
    Reset.enable = lib.mkEnableOption "Reset PC (SSD + HDD)";
    Reset-Netbook.enable = lib.mkEnableOption "Reset Netbook (SSD único)";
    Persistencia = {
      enable = lib.mkEnableOption "Habilitar Persistencia";
      extraSystemDirectories = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
      extraUserDirectories = lib.mkOption {
        type = lib.types.listOf lib.types.str;
        default = [ ];
      };
    };
  };

  config = lib.mkMerge [
    (lib.mkIf config.Reset.enable {
      fileSystems."/home".neededForBoot = true;
      fileSystems."/persist".neededForBoot = true;

      boot.initrd.systemd.services = {
        reset-root = mkResetService "p1" "root";
        reset-home = mkResetService "p2" "home";
      };

      systemd.services.setup-home = {
        description = "Configurar /home después del arranque";
        wantedBy = [ "multi-user.target" ];
        after = [ "local-fs.target" ];
        before = [ "display-manager.service" ];
        serviceConfig.Type = "oneshot";
        serviceConfig.RemainAfterExit = true;
        script = ''
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
        path = [ pkgs.coreutils ];
      };
    })

    (lib.mkIf config.Reset-Netbook.enable {
      fileSystems."/persist".neededForBoot = true;
      boot.initrd.systemd.services.reset-root = mkResetService "p1" "root";
    })

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
            ".cache/noctalia"
            ".config/sops"
            ".config/git"
            ".config/obsidian"
            ".config/zed/themes"
          ]
          ++ config.Persistencia.extraUserDirectories;
          files = [
            ".p10k.zsh"
            ".zshrc"
            ".mozilla/firefox/default/favicons.sqlite"
          ];
        };
      };
    })
  ];
}
