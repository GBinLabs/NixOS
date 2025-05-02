{pkgs, ...}: {
  home.packages = with pkgs; [
    (pkgs.python3.withPackages (python-pkgs: [
      ]))
  ];
}
