{config, lib, ...}: {

  options = {
	Git-PC.enable = lib.mkEnableOption "Habilitar Git-PC";
  };
  config = lib.mkIf config.Git-PC.enable  {
  programs.git = {
    enable = true;
    userName = "GBinLabs";
    userEmail = "197016998+GBinLabs@users.noreply.github.com";
    signing = {
      signByDefault = true;
      key = "~/.ssh/id_ed25519_PC"; # Sin el .pub
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
        identityFile = "~/.ssh/id_ed25519_PC";
        identitiesOnly = true;
      };
    };
  };

  services.ssh-agent.enable = true;
  };
}
