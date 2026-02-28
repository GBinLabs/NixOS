{ pkgs, ... }:
{
  services = {
    fwupd.enable = true;
    power-profiles-daemon.enable = true;
    scx = {
      enable = true;
      package = pkgs.scx.rustscheds;
      scheduler = "scx_bpfland";
      extraArgs = [
        "-m"
        "performance"
        "-w"
      ];
    };
    ratbagd = {
      enable = true;
      package = pkgs.libratbag;
    };
  };
}
