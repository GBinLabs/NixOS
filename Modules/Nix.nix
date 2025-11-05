# Modules/Nix.nix
{ lib, pkgs, ... }: {
  nix = {
    # === FLAKES ===
    settings = {
      experimental-features = ["nix-command" "flakes"];
      
      # === PERFORMANCE ===
      max-jobs = "auto";
      cores = 0;  # Usar todos los cores
      
      # Builders paralelos
      auto-optimise-store = true;
      
      # Cache
      keep-outputs = false;
      keep-derivations = false;
      
      # Timeouts
      connect-timeout = 5;
      stalled-download-timeout = 10;
      
      # Substituters optimizados
      substituters = [
        "https://cache.nixos.org"
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      
      # Optimizaciones
      warn-dirty = false;
      fallback = true;
      
      # Sistema de archivos
      fsync-metadata = false;
    };
    
    # === GARBAGE COLLECTION AGRESIVO ===
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
    
    # === OPTIMIZAR STORE ===
    optimise = {
      automatic = true;
      dates = [ "weekly" ];
    };
    
    # === EXTRA ===
    extraOptions = ''
      keep-outputs = false
      keep-derivations = false
      min-free = ${toString (1024 * 1024 * 1024)}
      max-free = ${toString (5 * 1024 * 1024 * 1024)}
    '';
  };
  
  # === SOFTWARE PROPIETARIO ===
  nixpkgs.config = {
    allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-original"
        "steam-unwrapped"
        "steam-run"
        "intel-ocl"
        "discord"
        "nvidia-x11"
        "nvidia-settings"
      ];
    
    # Permitir paquetes inseguros si es necesario
    allowInsecurePredicate = pkg: false;
  };
}
