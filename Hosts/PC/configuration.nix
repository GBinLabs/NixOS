{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../NixOS-modules/default.nix
    ./disko.nix
  ];

  # Autoupgrade
  Autoupgrade-Notebook.enable = false;
  Autoupgrade-PC.enable = true;
  Autoupgrade-Servidor.enable = false;
  # Final Autoupgrade.

  # Bluetooth.
  Bluetooth.enable = false;
  # Final Bluetooth.

  # Drivers
  # CPU.
  CPU-AMD.enable = true;
  CPU-Intel.enable = false;

  # GPU.
  GPU-AMD = {
    enable = true;
    gaming.enable = true;
  };
  GPU-Intel.enable = false;
  GPU-Nvidia.enable = false;
  # Final Drivers.

  # Impermanence.
  Persistente-Notebook.enable = false;
  Persistente-PC.enable = true;
  Persistente-Servidor.enable = false;
  # Final Impermanence.

  # Juegos.
  Steam.enable = true;
  Gamemode.enable = true;
  # Final Juegos.

  # RED.
  Red-Notebook.enable = false;
  Red-PC.enable = true;
  Red-Servidor.enable = false;
  # Final RED.

  # Asegurarse que systemd monte correctamente los sistemas de archivos
  fileSystems = {
    "/home".neededForBoot = true;
    "/persist".neededForBoot = true;
  };

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.mutableUsers = false;
  users.users.german = {
    isNormalUser = true;
    home = "/home/german";
    description = "Germán N. González";
    extraGroups = ["networkmanager" "wheel" "audio" "libvirtd" "kvm"];
    hashedPasswordFile = config.sops.secrets.usuario-german.path;
  };

  users.users.tecnico = {
    isNormalUser = true;
    description = "Técnico";
    extraGroups = [];
    initialPassword = "1234";
  };

  # DEJAR ASI #
  system.stateVersion = "24.11";
}
