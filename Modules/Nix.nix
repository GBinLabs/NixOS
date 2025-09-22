{lib, ...}: {
  # Flakes.
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
    };
  };
  # End Flakes.

  # Propietary Software.
  nixpkgs = {
    config = {
      allowUnfreePredicate = pkg:
        builtins.elem (lib.getName pkg) [
          "steam"
          "steam-original"
          "steam-unwrapped"
          "steam-run"
          "intel-ocl"
          "discord"
        ];
    };
  };
  # End Propietary Software.
}
