{...}: {
  imports = [
    ../../Home-manager/default.nix
  ];

  Aplicaciones-juegos.enable = false;
   
  # Git.
  Git-Notebook.enable = true;
  Git-PC.enable = false;
  # Final Git.
  
  # OBS.
  OBS-PC.enable = false;
  OBS-Notebook.enable = true;
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
