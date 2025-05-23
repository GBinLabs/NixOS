{ config, pkgs, ... }:

{

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
