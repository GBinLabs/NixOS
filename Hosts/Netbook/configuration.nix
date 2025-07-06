{ config, lib, pkgs, ... }:

{

  imports = [
  	./hardware-configuration.nix
  	../../NixOS-modules/default.nix
	./disko.nix
  ];
  
  # Drivers
  # CPU.
  CPU-AMD.enable = false;
  CPU-Intel.enable = true;

  # GPU.
  GPU-AMD.enable = false;
  GPU-Intel.enable = true;
  GPU-Nvidia.enable = false;
  # Final Drivers.
  
  # Impermanence.
  Persistente-Netbook.enable = true;
  Persistente-Notebook.enable = false;
  Persistente-PC.enable = false;
  # Final Impermanence.
  
  # Juegos.
  Gamemode.enable = false;
  Steam.enable = false;
  # Final Juegos.
  
  # RED.
  Red-Netbook.enable = true;
  Red-Notebook.enable = false;
  Red-PC.enable = false;
  # Final RED.
  
  # Usuarios.
  users.mutableUsers = false;
  users.users.german = {
	isNormalUser = true;
	description = "Germán N. González";
	extraGroups = [ "networkmanager" "wheel" "audio" ];
	hashedPasswordFile = config.sops.secrets.usuario-german.path;
  };
  # Final Usuarios.

  # ¡DEJAR ASI!#
  system.stateVersion = "24.11";

}
