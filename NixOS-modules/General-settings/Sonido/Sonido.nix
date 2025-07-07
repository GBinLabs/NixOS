{pkgs, ...}: {
  services = {
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse = {
        enable = true;
      };
      jack = {
        enable = true;
      };
      wireplumber = {
        enable = true;
        package = pkgs.wireplumber;
      };
    };
  };

  security = {
    rtkit = {
      enable = true;
    };
  };

  systemd = {
    user = {
      services = {
        set-microphone-volume = {
          description = "Establecer volumen del micrófono al 30%";
          wantedBy = ["pipewire.service"];
          after = ["pipewire.service" "wireplumber.service"];
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SOURCE@ 0.3";
            ExecStartPre = "${pkgs.coreutils}/bin/sleep 2";
          };
        };
      };
    };
  };
}
