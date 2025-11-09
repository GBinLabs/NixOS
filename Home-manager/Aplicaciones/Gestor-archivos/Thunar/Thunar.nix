{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      xfce.thunar
      xfce.thunar-archive-plugin
      xfce.thunar-bare
      xfce.thunar-dropbox-plugin
      xfce.thunar-media-tags-plugin
      xfce.thunar-vcs-plugin
      xfce.thunar-volman
    ];
  };
}
