{lib, ...}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
      "intel-ocl"
      "broadcom-sta"
      "discord"
      "nvidia-x11"
    ];
  nixpkgs.config.nvidia.acceptLicense = true;
}
