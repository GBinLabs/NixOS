{...}: {
  imports = [
    ../../Home-manager/default.nix
  ];

  # Aplicaciones juegos.
  Aplicaciones-juegos.enable = false;
  # Final Aplicaciones juegos.

  # Git.
  Git-Netbook.enable = false;
  Git-Notebook.enable = false;
  Git-PC.enable = true;
  # Final Git.

  # OBS.
  OBS-PC.enable = true;
  OBS-Notebook.enable = false;
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
