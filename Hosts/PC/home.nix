{...}: {
  imports = [
    ../../Home-manager/default.nix
  ];

  # Git.
  Git-Netbook.enable = false;
  Git-PC.enable = true;
  # Final Git.
  
  # Monitor.
  Monitor-Notebook.enable = false;
  Monitor-PC.enable = true;

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
