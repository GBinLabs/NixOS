{pkgs, ...}: {
  programs.nixcord = {
    enable = true;
    discord = {
      enable = false;
    };
    vesktop = {
      enable = false;
    };
    dorion = {
      enable = true;
      package = pkgs.dorion;
    };
  };
}
