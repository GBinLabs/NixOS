# Home-manager/Aplicaciones/default.nix
_: {
  imports = [
    ./Discord/Discord.nix
    ./Editores/default.nix
    ./General.nix
    ./Gestor-archivos/default.nix
    ./Git.nix
    ./Joplin.nix
    ./Languages/Python/Python.nix
    ./MangoHud/MangoHud.nix
    ./Navegadores/default.nix
    ./OBS/default.nix
    ./Terminales/default.nix
  ];
}
