{ config, pkgs, ... }:

{

  imports = [
	
  ];

  home.username = "german";
  home.homeDirectory = "/home/german";

  # ¡DEJAR ASI!
  home.stateVersion = "24.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
