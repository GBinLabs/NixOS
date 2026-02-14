{ pkgs, ... }:
{
  services = {
    pulseaudio = {
      enable = false;
    };
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
      };
      lowLatency = {
        enable = true;
        quantum = 64;
        rate = 48000;
      };
    };
  };

  security.rtkit.enable = true;

  systemd.user.services.microphone-volume = {
    description = "Configurar micrófono al 70%";
    wantedBy = [ "pipewire.service" ];
    after = [ "wireplumber.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = "${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.7";
    };
  };

}
