{
  description = "NixOS + Hyprland - Configuración de alto rendimiento";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
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

    nixcord = {
      url = "github:kaylorben/nixcord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    # Configuración base compartida
    baseModules = [
      inputs.disko.nixosModules.disko
      inputs.impermanence.nixosModules.impermanence
      inputs.sops-nix.nixosModules.sops

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

    # Development shell para testing
    devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShell {
      buildInputs = with nixpkgs.legacyPackages.${system}; [
        nixfmt-rfc-style
        statix
        deadnix
      ];
    };
  };
}
