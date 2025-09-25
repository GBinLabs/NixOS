{...}: {
  imports = [
    ../../Home-manager/default.nix
  ];

  # Git.
  Git-Netbook.enable = false;
  Git-PC.enable = true;
  # Final Git.

  # Usuario.
  home = {
    username = "Bin";
    homeDirectory = "/home/Bin";
    # ¡DEJAR ASI!
    stateVersion = "24.11";
  };
  # Final Usuario.

  # ¡DEJAR ASI!
  programs.home-manager.enable = true;
}
