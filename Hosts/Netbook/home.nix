{...}: {
  imports = [
    ../../Home-manager/default.nix
  ];

  # Git.
  Git-Netbook.enable = true;
  Git-Notebook.enable = false;
  Git-PC.enable = false;
  # Final Git.

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
