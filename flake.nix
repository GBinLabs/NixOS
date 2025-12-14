{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-facter-modules.url = "github:nix-community/nixos-facter-modules";

    impermanence.url = "github:nix-community/impermanence";

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    chaotic = {
      url = "https://flakehub.com/f/chaotic-cx/nyx/*.tar.gz";
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
    nixos-facter-modules,
    chaotic,
    nix-gaming,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    
    baseModules = [
      inputs.disko.nixosModules.disko
      inputs.nixos-facter-modules.nixosModules.facter
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
    mkHost = hostname: hostModule: homeModule: facterPath:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules =
          baseModules
          ++ [
            {facter.reportPath = facterPath;}
            hostModule
            {home-manager.users.german = homeModule;}
          ];
      };
  in {
    nixosConfigurations = {
      PC = mkHost "PC" ./Hosts/PC/configuration.nix ./Hosts/PC/home.nix ./Hosts/PC/facter.json;
      Notebook = mkHost "Notebook" ./Hosts/Notebook/configuration.nix ./Hosts/Notebook/home.nix ./Hosts/Notebook/facter.json;
      Netbook = mkHost "Netbook" ./Hosts/Netbook/configuration.nix ./Hosts/Netbook/home.nix ./Hosts/Netbook/facter.json;
    };
  };
  
  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://chaotic-nyx.cachix.org/"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
  };
}
