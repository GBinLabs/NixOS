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
    ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
    };
    udev.extraRules = ''
      # Scheduler óptimo según tipo de dispositivo
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="0", ATTR{queue/scheduler}="none"
      ACTION=="add|change", KERNEL=="sd[a-z]", ATTR{queue/rotational}=="1", ATTR{queue/scheduler}="bfq"
    '';
  };
}
