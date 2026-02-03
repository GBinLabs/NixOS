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
      # VS Code y extensiones
      "vscode"
      "vscode-extension-MS-python-vscode-pylance"
      "vscode-extension-ms-vscode-cpptools"
    ];
}
