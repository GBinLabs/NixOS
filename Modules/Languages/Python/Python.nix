{pkgs, ...}: {
  environment = {
    systemPackages = [
      (pkgs.python3.withPackages (python-pkgs: [
        python-pkgs.pygments
      ]))
    ];
  };
}
