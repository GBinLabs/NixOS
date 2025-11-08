# Hosts/Netbook/configuration.nix
{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../Modules/default.nix
    ./disko.nix
  ];

  # En configuration.nix
  CPU-Intel = {
    enable = true;
    cpuOffset = -50; # -50mV (agresivo)
    gpuOffset = -50; # -50mV
  };
  GPU-Intel = {
    enable = true;
    # Opcional: personalizar
    maxFreq = 550; # 550MHz = undervolt agresivo
    rc6Level = 3; # deepest power saving
  };
  Zram.enable = true;
  Persistente.enable = true;
  Reset-Netbook.enable = true;
  Red-Netbook.enable = true;

  users.mutableUsers = false;
  users.users.german = {
    isNormalUser = true;
    description = "Germán N. González";
    extraGroups = ["networkmanager" "wheel" "audio" "video"];
    hashedPasswordFile = config.sops.secrets.usuario-german.path;
  };

  system.stateVersion = "24.11";
}
