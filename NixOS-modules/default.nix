{...}: {
  imports = [
    ./Display-manager/default.nix
    ./Drivers/default.nix
    ./Fonts/default.nix
    ./General-settings/default.nix
    ./Security/Sops-Nix/Sops-Nix.nix
    ./Window-manager/default.nix
  ];
}
