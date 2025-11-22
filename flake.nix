{
  description = "NixOS + Hyprland - Configuración de alto rendimiento";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    chaotic = {
    	url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    	inputs.nixpkgs.follows = "nixpkgs";
    };
    

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    chaotic,
    nix-gaming,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    # Configuración base compartida
    baseModules = [
      inputs.disko.nixosModules.disko
      inputs.impermanence.nixosModules.impermanence
      inputs.sops-nix.nixosModules.sops
      chaotic.nixosModules.default
      inputs.nix-gaming.nixosModules.platformOptimizations
      inputs.nix-gaming.nixosModules.pipewireLowLatency

      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "backup";
          sharedModules = [
            inputs.nixcord.homeModules.nixcord
          ];
        };
      }
    ];

    # Función helper para crear hosts
    mkHost = hostname: hostModule: homeModule:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules =
          baseModules
          ++ [
            hostModule
            {home-manager.users.german = homeModule;}
          ];
      };
  in {
    nixosConfigurations = {
      PC = mkHost "PC" ./Hosts/PC/configuration.nix ./Hosts/PC/home.nix;
      Notebook = mkHost "Notebook" ./Hosts/Notebook/configuration.nix ./Hosts/Notebook/home.nix;
      Netbook = mkHost "Netbook" ./Hosts/Netbook/configuration.nix ./Hosts/Netbook/home.nix;
    };
  };
  
  nixConfig = {
    extra-substituters = [
      "https://chaotic-nyx.cachix.org/"
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };
}
