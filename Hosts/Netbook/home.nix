{ config, pkgs, ... }:

{

  imports = [
	../../Home-manager/default.nix
  ];

  Aplicaciones-juegos.enable = false;
   
  # Git.
  Git-Netbook.enable = true;
  Git-Notebook.enable = false;
  Git-PC.enable = false;
  # Final Git.
  
  # OBS.
  OBS-PC.enable = false;
  OBS-Notebook.enable = true;
  # Final OBS.

  home.username = "german";
  home.homeDirectory = "/home/german";

  # ¡DEJAR ASI!
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
