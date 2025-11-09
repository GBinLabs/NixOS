# Home-manager/Aplicaciones/default.nix
_: {
  imports = [
    ./Discord.nix
    ./Editores/default.nix
    ./General.nix
    ./Gestor-archivos/default.nix
    ./Git.nix
    #./Joplin.nix
    ./Languages/Python/Python.nix
    ./MangoHud.nix
    ./Navegadores/default.nix
    ./OBS/default.nix
    ./Terminales/default.nix
  ];
}
