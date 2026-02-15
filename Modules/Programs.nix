{ pkgs, ... }:
{
  programs = {
    java = {
      enable = true;
      package = pkgs.temurin-bin-25;
    };
    nh = {
      enable = true;
      clean = {
        enable = true;
        extraArgs = "--keep-since 7d --keep 5";
      };
      flake = "/home/german/.GitHub/NixOS";
    };
    nix-ld = {
      enable = true;
    };
  };
}
