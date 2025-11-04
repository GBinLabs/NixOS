# Hosts/PC/configuration.nix
{ config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../Modules/default.nix
    ./disko.nix
  ];

  # === DRIVERS ===
  CPU-AMD = {
    enable = true;
    performanceProfile = "gaming";
    enableSchedulerTweaks = true;
    enableCPUBoost = true;
  };

  GPU-AMD = {
    enable = true;
    performanceProfile = "gaming";
    enableTuning = true;  # Para usar LACT
  };

  # === OPTIMIZACIONES ===
  Zram.enable = true;
  
  # === GAMING ===
  Steam.enable = true;
  
  # === RESTO ===
  Persistente-PC.enable = true;
  Reset.enable = true;
  Red-PC.enable = true;

  # Usuarios
  users.mutableUsers = false;
  users.users.german = {
    isNormalUser = true;
    description = "Germán N. González";
    extraGroups = [ "networkmanager" "wheel" "audio" "gamemode" "video" ];
    hashedPasswordFile = config.sops.secrets.usuario-german.path;
  };

  system.stateVersion = "24.11";
}
