# Modules/Zsh.nix
{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;
    enableGlobalCompInit = false; # Faster startup

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "copypath"
        "dirhistory"
      ];
    };

    promptInit = ''
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';

    histSize = 10000;
    histFile = "$HOME/.zsh_history";

    setOptions = [
      "HIST_IGNORE_ALL_DUPS"
      "HIST_SAVE_NO_DUPS"
      "HIST_REDUCE_BLANKS"
      "SHARE_HISTORY"
      "INC_APPEND_HISTORY"
    ];

    # Aliases útiles
    shellAliases = {
      # Sistema
      rebuild = "sudo nixos-rebuild switch --flake ~/.config/nixos";
      update = "nix flake update ~/.config/nixos && rebuild";
      clean = "nix-collect-garbage -d && sudo nix-collect-garbage -d";
      optimise = "nix-store --optimise";

      # Utils
      ls = "ls --color=auto";
      ll = "ls -lah";
      grep = "grep --color=auto";

      # Git shortcuts
      gs = "git status";
      ga = "git add";
      gc = "git commit";
      gp = "git push";
      gl = "git pull";

      # Performance
      mem = "free -h";
      cpu = "htop";
      temps = "watch -n1 sensors";
    };
  };

  environment.shells = with pkgs; [zsh];
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = with pkgs; [
    zsh
    zsh-powerlevel10k
    oh-my-zsh
  ];

  # Optimización de compinit
  environment.etc."zshenv".text = ''
    skip_global_compinit=1
  '';
}
