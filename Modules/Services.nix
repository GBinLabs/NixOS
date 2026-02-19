{ pkgs, ... }:
{
  services = {
    fwupd.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
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
    tuned = {
      enable = true;
      ppdSettings = {
        main = {
          default = "performance";
          battery_detection = false;
        };
        profiles = {
          performance = "latency-performance";
        };
      };
    };
    upower = {
      enable = true;
    };
  };

  environment.systemPackages = with pkgs; [ usbutils ];

}
