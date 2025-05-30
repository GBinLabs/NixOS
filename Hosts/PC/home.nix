{...}: {
  imports = [
    ../../Home-manager/default.nix
  ];

  Aplicaciones-juegos.enable = true;
  
  # Git.
  Git-Notebook.enable = false;
  Git-PC.enable = true;
  # Final Git.
  
  # OBS.
  OBS-PC.enable = true;
  OBS-Notebook.enable = false;
  # Final OBS.

  home = {
    username = "german";
    homeDirectory = "/home/german";
    # ¡DEJAR ASI!
    stateVersion = "24.11";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
