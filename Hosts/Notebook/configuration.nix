{
  config,
  pkgs,
  lib,
  ...
}: 

{
  imports = [
    ./hardware-configuration.nix
    ../../NixOS-modules/default.nix
    ./disko.nix
  ];


  # Autoupgrade
  Autoupgrade-Notebook.enable = true;
  Autoupgrade-PC.enable = false;
  Autoupgrade-Servidor.enable = false;
  # Final Autoupgrade.
  
  # Bluetooth.
  Bluetooth.enable = true;
  # Final Bluetooth.

  # Drivers
  # CPU.
  CPU-AMD.enable = false;
  CPU-Intel.enable = true;

  # GPU.
  GPU-AMD = {
    enable = false;
  };
  GPU-Intel.enable = false;
  GPU-Nvidia.enable = true;
  # Final Drivers.

  # Impermanence.
  Persistente-Notebook.enable = true;
  Persistente-PC.enable = false;
  Persistente-Servidor.enable = false;
  # Final Impermanence.

  # Juegos.
  Steam.enable = false;
  Gamemode.enable = false;
  # Final Juegos.

  # RED.
  Red-Notebook.enable = true;
  Red-PC.enable = false;
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
    extraGroups = ["networkmanager" "wheel" "audio"];
    hashedPasswordFile = config.sops.secrets.usuario-german.path;
  };

  system.stateVersion = "24.11"; # Did you read the comment?
}
