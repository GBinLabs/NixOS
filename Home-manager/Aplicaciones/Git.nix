# Home-manager/Aplicaciones/Git/Git.nix
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
      userName = "GBinLabs";
      userEmail = "197016998+GBinLabs@users.noreply.github.com";
      
      signing = {
        signByDefault = true;
        key = config.git-config.keyFile;
      };
      
      extraConfig = {
        init.defaultBranch = "main";
        gpg.format = "ssh";
        
        # Optimizaciones
        core.fsmonitor = true;
        core.untrackedCache = true;
        feature.manyFiles = true;
        
        # Delta para diffs bonitos
        core.pager = "delta";
        interactive.diffFilter = "delta --color-only";
        delta.navigate = true;
        merge.conflictstyle = "diff3";
        diff.colorMoved = "default";
      };
    };

    programs.ssh = {
      enable = true;
      addKeysToAgent = "yes";
      
      matchBlocks."github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = config.git-config.keyFile;
        identitiesOnly = true;
      };
    };

    services.ssh-agent.enable = true;
    
    # Delta para diffs mejorados
    home.packages = [ pkgs.delta ];
  };
}
