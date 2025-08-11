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
          "intel-ocl"
        ];
    };
  };
  # End Propietary Software.
}
