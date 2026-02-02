# Modules/default.nix
_: {
  imports = [
    ./Audio.nix
    ./Boot.nix
    ./DNS.nix
    ./Desktop/default.nix
    ./Impermanence.nix
    ./Keyboard.nix
    ./LanguageTool.nix
    ./Nix.nix
    ./Programs.nix
    ./Red.nix
    ./Security/default.nix
    ./Services.nix
    ./Steam.nix
    ./Zram.nix
    ./Zsh.nix
  ];
}
