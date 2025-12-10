# Modules/default.nix
_: {
  imports = [
    ./Audio.nix
    ./Boot.nix
    ./DNS.nix
    ./Desktop/default.nix
    ./Impermanence/default.nix
    ./Keyboard.nix
    ./Network/default.nix
    ./Nix.nix
    ./Programs.nix
    ./Security/default.nix
    ./Services.nix
    ./Zram.nix
    ./Zsh.nix
  ];
}
