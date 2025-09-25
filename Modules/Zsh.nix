{ pkgs, config, ... }:
{
  # Instala zsh y lo habilita
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestions.enable = true;

    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
      ];
    };
    
    promptInit = ''
      # Source the theme directly from the Nix store
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      # Source your persisted configuration
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
    '';

    histSize = 10000;
    histFile = "$HOME/.zsh_history";
    setOptions = [ "HIST_IGNORE_ALL_DUPS" ];
  };

  # Para que /etc/shells incluya zsh
  environment.shells = with pkgs; [ zsh ];

  # Establecer zsh como shell por defecto para todos los usuarios
  users.defaultUserShell = pkgs.zsh;

  # Incluir paquetes globales
  environment.systemPackages = with pkgs; [
    zsh
    zsh-powerlevel10k
    oh-my-zsh
  ];
}

