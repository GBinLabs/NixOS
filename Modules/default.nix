# Modules/default.nix
_: {
  imports = [
    ./Audio.nix
    ./Bluetooth.nix
    ./Boot.nix
    ./DNS.nix
    ./Drivers/default.nix
    ./Desktop/default.nix
    ./Impermanence/default.nix
    ./Keyboard.nix
    ./Network/default.nix
    ./Nix.nix
    ./Programs.nix
    ./Security/default.nix
    ./Services.nix
    ./Session.nix
    ./Steam.nix
    ./Zram.nix
    ./Zsh.nix
  ];
}
