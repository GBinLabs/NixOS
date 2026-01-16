# Modules/Nix.nix
{lib, ...}: {
  nix = {
    settings = {
      experimental-features = ["nix-command" "flakes"];
      max-jobs = "auto";
      cores = 0;
      auto-optimise-store = true;
      allowed-users = ["german"];
      trusted-users = ["root" "german"];
      warn-dirty = false;
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    optimise.automatic = true;
  };

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [ 
      "steam"
      "steam-original"
      "steam-unwrapped"
      "steam-run"
      "discord"
      "obsidian"
      "vscode-extension-MS-python-vscode-pylance"
    ];
}
