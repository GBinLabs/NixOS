{ pkgs, ... }:
{
  services = {
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
      wireplumber.enable = true;
      lowLatency = {
        enable = true;
        quantum = 64;
        rate = 48000;
      };
    };
  };

  security.rtkit.enable = true;

  systemd.user.services.microphone-volume = {
    description = "Configurar micrófono al 30%";
    wantedBy = [ "graphical-session.target" ];
    after = [ "wireplumber.service" "pipewire.service" ];
    requires = [ "wireplumber.service" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "set-mic-volume" ''
        # Esperar hasta que WirePlumber esté completamente inicializado
        # y exista un source de audio por defecto
        max_attempts=30
        attempt=0

        while [ $attempt -lt $max_attempts ]; do
          # Verificar si existe un default audio source
          if ${pkgs.wireplumber}/bin/wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null | grep -q "Volume"; then
            ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.3
            echo "Volumen del micrófono configurado al 30%"
            exit 0
          fi

          attempt=$((attempt + 1))
          sleep 1
        done

        echo "No se pudo configurar el volumen del micrófono después de $max_attempts intentos"
        exit 1
      '';
    };
  };
}
