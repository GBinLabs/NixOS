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
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    nixos-facter-modules,
    ...
  } @ inputs: let
    system = "x86_64-linux";

    # Configuración base compartida
    baseModules = [
      inputs.disko.nixosModules.disko
      inputs.nixos-facter-modules.nixosModules.facter
      inputs.impermanence.nixosModules.impermanence
      inputs.sops-nix.nixosModules.sops
      home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          backupFileExtension = "backup";
          sharedModules = [
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
}
