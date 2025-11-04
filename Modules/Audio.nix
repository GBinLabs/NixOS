{ pkgs, ... }: {
  # ===== PIPEWIRE OPTIMIZADO =====
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;

    # Baja latencia + alta calidad
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 512;  # Reducido de 1024
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 2048;
      };
    };

    extraConfig.pipewire-pulse."92-low-latency" = {
      "pulse.properties" = {
        "pulse.min.req" = "512/48000";      # Latencia ~10ms
        "pulse.default.req" = "512/48000";
        "pulse.max.req" = "512/48000";
        "pulse.min.quantum" = "512/48000";
        "pulse.max.quantum" = "512/48000";
      };
      "stream.properties" = {
        "node.latency" = "512/48000";
        "resample.quality" = 10;  # Calidad máxima
      };
    };

    wireplumber.enable = true;
  };

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    pavucontrol
    pwvucontrol
    easyeffects
  ];

  # ===== SERVICIO SIMPLIFICADO PARA VOLUMEN DE MICRÓFONO =====
  systemd.user.services.mic-volume-fix = {
    description = "Ajustar volumen de micrófono";
    after = [ "pipewire.service" "wireplumber.service" ];
    wantedBy = [ "graphical-session.target" ];
    
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "mic-volume-fix" ''
        sleep 3
        ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SOURCE@ 30%
      '';
    };
  };
}
