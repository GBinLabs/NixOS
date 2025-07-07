{pkgs, ...}: {
  programs.joplin-desktop = {
    enable = true;
    package = pkgs.joplin-desktop;
    sync.target = "joplin-cloud";
    sync.interval = "5m";
  };
}
