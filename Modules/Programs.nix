{pkgs, ...}: {
  programs = {
    java = {
      enable = true;
      package = pkgs.zulu25;
    };
    nm-applet = {
      enable = true;
    };
  };
}
