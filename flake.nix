{
  description = "Configuración personalizada";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    disko = {
      url = "github:nix-community/disko/latest";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence = {
      url = "github:nix-community/impermanence";
    };
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
    nixpkgs,
    disko,
    home-manager,
    impermanence,
    sops-nix,
    ...
  } @ inputs: {
    nixosConfigurations = {
      Netbook = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          sops-nix.nixosModules.sops
          ./Hosts/Netbook/configuration.nix
          {
            nixpkgs.overlays = [
            ];
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.german = import ./Hosts/Netbook/home.nix;
              backupFileExtension = "backup";
              sharedModules = [
              ];
            };
          }
        ];
      };
      PC = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          disko.nixosModules.disko
          impermanence.nixosModules.impermanence
          sops-nix.nixosModules.sops
          ./Hosts/PC/configuration.nix
          {
            nixpkgs.overlays = [
            ];
          }
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.german = import ./Hosts/PC/home.nix;
              #users.tecnico = import ./Hosts/Bin-PC/home-tecnico.nix;
              backupFileExtension = "backup";
              sharedModules = [
                inputs.nixcord.homeModules.nixcord
              ];
            };
          }
        ];
      };
    };
  };
}
