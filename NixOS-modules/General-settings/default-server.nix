{...}: {
  imports = [
    ./Autoupgrade/default.nix
    ./Bluetooth/Bluetooth.nix
    ./Bootloader/Bootloader.nix
    ./DNS/DNS.nix
    ./Flakes/Flakes.nix
    ./Impermanence/Persistente/default.nix
    ./Java/Java.nix
    ./Kernel/Kernel.nix
    ./Red/default.nix
    ./Software-privativo/Software-privativo.nix
    ./Sonido/Sonido.nix
    ./Teclado/Teclado.nix
    ./USB/USB.nix
    ./Zona-horaria/Zona-horaria.nix
  ];
}
