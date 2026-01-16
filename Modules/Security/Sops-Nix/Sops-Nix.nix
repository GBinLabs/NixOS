{ pkgs, ... }:
{
  sops = {
    defaultSopsFile = ../../../Secrets/secrets.yaml;
    defaultSopsFormat = "yaml";

    age = {
      keyFile = "/persist/home/german/.config/sops/age/keys.txt";
    };
    secrets = {
      usuario-german = {
        neededForUsers = true;
      };
    };
  };
  environment.systemPackages = with pkgs; [
    age
    sops
  ];
}
