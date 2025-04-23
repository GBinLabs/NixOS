{...}: {
  imports = [
    ../../Home-manager/default.nix
  ];

  Aplicaciones-juegos.enable = true;
  
  # Git.
  Git-Notebook.enable = false;
  Git-PC.enable = true;
  # Final Git.
  
  # Monitor.
  Monitor-Notebook.enable = false;
  Monitor-PC.enable = true;
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
