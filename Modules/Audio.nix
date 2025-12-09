{pkgs, ...}: {
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;
    lowLatency = {
      enable = true;
      quantum = 64;
      rate = 48000;
    };

    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/wireplacker/wireplumber.conf.d/51-alsa-disable-dsp.conf" ''
          monitor.alsa.rules = [
            {
              matches = [{ node.name = "~alsa_.*" }]
              actions = {
                update-props = {
                  audio.format = "S16LE"
                  audio.rate = 48000
                  api.alsa.period-size = 512
                  api.alsa.headroom = 512
                }
              }
            }
          ]
        '')
      ];
    };
  };

  security.rtkit.enable = true;

  systemd.user.services.microphone-volume = {
    description = "Configurar micrófono al 30%";
    wantedBy = ["graphical-session.target"];
    after = ["wireplumber.service"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "set-mic-volume" ''
        for i in {1..10}; do
          MIC=$(${pkgs.wireplumber}/bin/wpctl status | grep -i "microphone" | head -n1 | cut -d'.' -f1 | tr -d ' ')
          if [ -n "$MIC" ]; then
            ${pkgs.wireplumber}/bin/wpctl set-volume "$MIC" 0.3
            exit 0
          fi
          sleep 1
        done
        ${pkgs.pulseaudio}/bin/pactl set-source-volume @DEFAULT_SOURCE@ 30%
      '';
    };
  };
}
