{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../Modules/default.nix
    ./disko.nix
  ];

  CPU-Intel = {
    enable = true;
    powerProfile = "balanced";
  };

  GPU-Intel = {
    enable = true;
    vaDriver = "iHD";
    enableOptimizations = true;
    powerProfile = "balanced";
  };

  # MISMAS optimizaciones que PC
  Gaming-Optimization.enable = true;  # ← IGUAL que PC
  Ananicy-CPP.enable = true;          # ← IGUAL que PC
  Zram.enable = true;                 # ← IGUAL que PC
  
  # Solo para Netbook (universidad)
  DNS-Smart.enable = true;  # ← NUEVO
  
  Persistente.enable = true;
  Reset-Netbook.enable = true;
  Red-Netbook.enable = true;

  users.mutableUsers = false;
  users.users.german = {
    isNormalUser = true;
    description = "Germán N. González";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    hashedPasswordFile = config.sops.secrets.usuario-german.path;
  };

  system.stateVersion = "24.11";
}
