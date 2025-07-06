{...}: {
  imports = [
    ../../Home-manager/default.nix
  ];

  # Aplicaciones juegos.
  Aplicaciones-juegos.enable = false;
  # Final Aplicaciones juegos.

  # Git.
  Git-Netbook.enable = false;
  Git-Notebook.enable = true;
  Git-PC.enable = false;
  # Final Git.

  # OBS.
  OBS-PC.enable = false;
  OBS-Notebook.enable = true;
  # Final OBS.

  # Usuario.
  home = {
    username = "german";
    homeDirectory = "/home/german";
    # ¡DEJAR ASI!
    stateVersion = "24.11";
  };
  # Final Usuario.

  # ¡DEJAR ASI!
  programs.home-manager.enable = true;
}
