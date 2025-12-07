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
    targetTemp = 85000;
    minFreq = 2400;
  };
  GPU-Intel = {
    enable = true;
    maxFreq = 650;
    rc6Level = 0;
  };
  Zram.enable = true;
  Persistencia.enable = true;
  Reset-Netbook.enable = true;
  Red-Netbook.enable = true;
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    VDPAU_DRIVER = "va_gl";
  };

  users.mutableUsers = false;
  users.users.german = {
    isNormalUser = true;
    description = "Germán N. González";
    extraGroups = ["networkmanager" "wheel" "audio" "video"];
    hashedPasswordFile = config.sops.secrets.usuario-german.path;
    initialPassword = "1234";
  };

  system.stateVersion = "24.11";
}
