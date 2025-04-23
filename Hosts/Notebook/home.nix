{...}: {
  imports = [
    ../../Home-manager/default.nix
  ];

  Aplicaciones-juegos.enable = false;
   
  # Git.
  Git-Notebook.enable = true;
  Git-PC.enable = false;
  # Final Git.

  # Monitor.
  Monitor-Notebook.enable = true;
  Monitor-PC.enable = false;
  # Final Monitor.

  home = {
    username = "german";
    homeDirectory = "/home/german";
    # ¡DEJAR ASI!
    stateVersion = "24.11";
  };
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
