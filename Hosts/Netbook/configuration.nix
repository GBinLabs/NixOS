# Hosts/Netbook/configuration.nix
{ config, ... }: {
  imports = [
    ./hardware-configuration.nix
    ../../Modules/default.nix
    ./disko.nix
  ];

  # === DRIVERS ===
  CPU-Intel = {
    enable = true;
    powerProfile = "powersave";  # balanced o powersave en batería
  };

  GPU-Intel = {
    enable = true;
    vaDriver = "iHD";  # UHD 600 es Gen 9.5
    enableOptimizations = true;
    powerProfile = "powersave";
  };

  # === OPTIMIZACIONES ===
  # NO usar Zram en netbook con poca RAM - usar swap tradicional
  Zram.enable = true;

  # === IMPERMANENCE ===
  Persistente.enable = true;
  Reset-Netbook.enable = true;

  # === RED ===
  Red-Netbook.enable = true;

  # === SERVICIOS DE BAJO CONSUMO ===
  services = {
    # Thermald para control térmico Intel
    thermald.enable = true;
    
    # Auto-CPUfreq (alternativa a TLP, más simple)
    # auto-cpufreq.enable = true;
    
    # Deshabilitar servicios innecesarios
    printing.enable = false;  # Si no usas impresora
    avahi.enable = false;     # Descubrimiento de red
  };

  # Usuarios
  users.mutableUsers = false;
  users.users.german = {
    isNormalUser = true;
    description = "Germán N. González";
    extraGroups = [ "networkmanager" "wheel" "audio" "video" ];
    hashedPasswordFile = config.sops.secrets.usuario-german.path;
  };

  system.stateVersion = "24.11";
}
