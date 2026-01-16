# Hosts/Netbook/home.nix
{ ... }:
{
  imports = [ ../../Home-manager/default.nix ];

  git-config = {
    enable = true;
    keyFile = "~/.ssh/id_ed25519_Netbook";
  };

  home = {
    username = "german";
    homeDirectory = "/home/german";
    stateVersion = "24.11";
  };

  programs.home-manager.enable = true;
}
