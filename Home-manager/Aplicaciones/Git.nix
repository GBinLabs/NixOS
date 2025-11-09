# Home-manager/Aplicaciones/Git.nix
{ config, lib, pkgs, ... }: {
  options = {
    git-config = {
      enable = lib.mkEnableOption "Habilitar Git";
      
      keyFile = lib.mkOption {
        type = lib.types.str;
        description = "Ruta a la clave SSH";
      };
    };
  };

  config = lib.mkIf config.git-config.enable {
    programs.git = {
      enable = true;
      
      # Nueva sintaxis para settings
      settings = {
        user = {
          name = "GBinLabs";
          email = "197016998+GBinLabs@users.noreply.github.com";
        };
        
        init.defaultBranch = "main";
        gpg.format = "ssh";
        
        # Optimizaciones
        core = {
          fsmonitor = true;
          untrackedCache = true;
          pager = "delta";
        };
        
        feature.manyFiles = true;
        
        # Delta
        interactive.diffFilter = "delta --color-only";
        delta = {
          navigate = true;
          line-numbers = true;
          side-by-side = true;
        };
        
        merge.conflictstyle = "diff3";
        diff.colorMoved = "default";
        
        # Performance
        pack = {
          threads = "0";
          windowMemory = "100m";
        };
        
        # Aliases (nueva ubicación)
        alias = {
          st = "status -sb";
          co = "checkout";
          br = "branch";
          ci = "commit";
          l = "log --oneline --graph --decorate";
          ll = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset'";
          unstage = "reset HEAD --";
          last = "log -1 HEAD";
          visual = "log --graph --all --oneline --decorate";
        };
      };
      
      # Signing
      signing = {
        signByDefault = true;
        key = config.git-config.keyFile;
      };
    };

    programs.ssh = {
      enable = true;
      
      # Nueva sintaxis
      enableDefaultConfig = true;
      
      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
        };
        
        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = config.git-config.keyFile;
          identitiesOnly = true;
        };
      };
    };

    services.ssh-agent.enable = true;
    
    home.packages = with pkgs; [ delta gh ];
  };
}
