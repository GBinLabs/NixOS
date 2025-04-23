{config , lib, ...}: {

  options = {
	Git-Notebook.enable = lib.mkEnableOption "Habilitar Git en Notebook";
  };
  config = lib.mkIf config.Git-Notebook.enable  {
  
  programs.git = {
    enable = true;
    userName = "GBinLabs";
    userEmail = "197016998+GBinLabs@users.noreply.github.com";
    signing = {
      signByDefault = true;
      key = "~/.ssh/id_ed25519_Notebook"; # Sin el .pub
    };
    extraConfig = {
      init.defaultBranch = "main";
      gpg.format = "ssh";
    };
  };

  programs.ssh = {
    enable = true;
    addKeysToAgent = "yes";
    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519_Notebook";
        identitiesOnly = true;
      };
    };
  };

  services.ssh-agent.enable = true;
  };
}
