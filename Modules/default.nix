# Modules/default.nix
_: {
  imports = [
    ./Audio.nix
    ./Bluetooth.nix
    ./Boot.nix
    ./DNS.nix
    ./General.nix
    ./Git.nix
    ./Helix.nix
    ./Drivers/default.nix
    ./Impermanence/default.nix
    ./Keyboard.nix
    ./Kitty.nix
    ./Languages/Python/Python.nix
    ./Librewolf/Librewolf.nix
    ./Monitor.nix
    ./Network/default.nix
    ./Network-Optimization.nix
    ./Nix.nix
    ./OBS.nix
    ./Programs.nix
    ./Security/default.nix
    ./Services.nix
    ./Session.nix
    ./Steam.nix
    ./Window-Manager/default.nix
    ./Yazi.nix
    ./Zram.nix
    ./Zsh.nix
  ];
}
