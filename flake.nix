{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

    home-manager = {
      url = "github:nix-community/home-manager";
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
    
    hyprland.url = "github:hyprwm/Hyprland";
    
    silentSDDM = {
      url = "github:uiriansan/SilentSDDM";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
        noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };	
    
    nix-vscode-extensions.url = "github:nix-community/nix-vscode-extensions";

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    hytale-launcher.url = "github:JPyke3/hytale-launcher-nix";

    nixcord.url = "github:FlameFlag/nixcord";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixos-facter-modules,
      hyprland,
      nix-vscode-extensions,
      nix-gaming,
      nix-cachyos-kernel,
      hytale-launcher,
      ...
    }@inputs:
    let
      system = "x86_64-linux";

      baseModules = [
        inputs.disko.nixosModules.disko
        inputs.nixos-facter-modules.nixosModules.facter
        inputs.impermanence.nixosModules.impermanence
        inputs.sops-nix.nixosModules.sops
        inputs.hyprland.nixosModules.default
        inputs.silentSDDM.nixosModules.default
        inputs.nix-gaming.nixosModules.platformOptimizations
        inputs.nix-gaming.nixosModules.pipewireLowLatency
        home-manager.nixosModules.home-manager
        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            sharedModules = [
              inputs.hyprland.homeManagerModules.default
              inputs.noctalia.homeModules.default
              inputs.nixcord.homeModules.nixcord
            ];
          };
        }
      ];

      # Función helper para crear hosts
      mkHost =
        hostname: hostModule: homeModule: facterPath:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = baseModules ++ [
            (
              { inputs, ... }:
              {
                nixpkgs.overlays = [
                  inputs.nix-cachyos-kernel.overlays.pinned
                  inputs.nix-vscode-extensions.overlays.default
                  (final: prev: {
                    hytale-launcher = inputs.hytale-launcher.packages.${system}.default;
                  })
                ];
              }
            )
            { facter.reportPath = facterPath; }
            hostModule
            { home-manager.users.german = homeModule; }
          ];
        };
    in
    {
      nixosConfigurations = {
        PC = mkHost "PC" ./Hosts/PC/configuration.nix ./Hosts/PC/home.nix ./Hosts/PC/facter.json;
        Notebook =
          mkHost "Notebook" ./Hosts/Notebook/configuration.nix ./Hosts/Notebook/home.nix
            ./Hosts/Notebook/facter.json;
        Netbook =
          mkHost "Netbook" ./Hosts/Netbook/configuration.nix ./Hosts/Netbook/home.nix
            ./Hosts/Netbook/facter.json;
      };
    };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://attic.xuyh0120.win/lantian"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };
}
