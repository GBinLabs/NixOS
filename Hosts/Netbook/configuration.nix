# Hosts/Netbook/configuration.nix
{config, ...}: {
  imports = [
    ./hardware-configuration.nix
    ../../Modules/default.nix
    ./disko.nix
  ];

  CPU-Intel.enable = true;
  GPU-Intel.enable = true;
  Zram.enable = true;
  Persistencia.enable = true;
  Reset-Netbook.enable = true;
  Red-Netbook.enable = true;
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
    VDPAU_DRIVER = "va_gl";
  };

  boot.kernelModules = ["snd_hda_intel"];
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0
  '';

  users.mutableUsers = false;
  users.users.german = {
    isNormalUser = true;
    description = "Germán N. González";
    extraGroups = ["networkmanager" "wheel" "audio" "video"];
    hashedPasswordFile = config.sops.secrets.usuario-german.path;
  };

  system.stateVersion = "24.11";
}
