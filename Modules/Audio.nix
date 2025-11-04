# MEJORAS PARA Modules/Audio.nix
# REEMPLAZAR el archivo completo con esta versión optimizada para gaming

{ pkgs, ... }: {
  # ===== PIPEWIRE ULTRA-BAJO LATENCY =====
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;

    # LATENCIA ULTRA-BAJA para gaming competitivo
    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 256;        # REDUCIDO de 512 (5.3ms @ 48kHz)
        "default.clock.min-quantum" = 32;      # Mínimo posible
        "default.clock.max-quantum" = 2048;
      };
      
      "context.modules" = [
        {
          name = "libpipewire-module-rt";
          args = {
            "nice.level" = -20;                 # Máxima prioridad
            "rt.prio" = 95;                     # Realtime priority
            "rt.time.soft" = 2000000;           # 2s
            "rt.time.hard" = 2000000;
          };
          flags = [ "ifexists" "nofail" ];
        }
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            "server.address" = [ "unix:native" ];
            "pulse.min.req" = "256/48000";     # Match quantum
            "pulse.min.quantum" = "256/48000";
            "pulse.max.quantum" = "256/48000";
          };
        }
      ];
    };

    extraConfig.pipewire-pulse."92-low-latency" = {
      "pulse.properties" = {
        "pulse.min.req" = "256/48000";         # REDUCIDO: ~5.3ms
        "pulse.default.req" = "256/48000";
        "pulse.max.req" = "256/48000";
        "pulse.min.quantum" = "256/48000";
        "pulse.max.quantum" = "256/48000";
      };
      
      "stream.properties" = {
        "node.latency" = "256/48000";
        "resample.quality" = 10;                # Máxima calidad
        "resample.disable" = false;             # Permitir resample de alta calidad
        "channelmix.normalize" = true;
        "channelmix.mix-lfe" = true;
        "node.pause-on-idle" = false;          # CRÍTICO: No pausar nunca
      };
      
      "pulse.rules" = [
        # CS2 y juegos de Source 2
        {
          matches = [
            { "application.process.binary" = "cs2"; }
            { "application.process.binary" = "dota2"; }
            { "application.process.binary" = "csgo"; }
          ];
          actions = {
            update-props = {
              "node.latency" = "128/48000";    # 2.6ms para CS2
              "pulse.min.quantum" = "128/48000";
              "pulse.max.quantum" = "128/48000";
              "node.pause-on-idle" = false;
              "session.suspend-timeout-seconds" = 0;
            };
          };
        }
        # Discord/TeamSpeak
        {
          matches = [
            { "application.name" = "Discord"; }
            { "application.name" = "TeamSpeak"; }
          ];
          actions = {
            update-props = {
              "node.latency" = "512/48000";     # Mayor latencia OK para VoIP
              "pulse.min.quantum" = "512/48000";
            };
          };
        }
      ];
    };

    wireplumber = {
      enable = true;
      
      # Configuración de WirePlumber para gaming
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/99-gaming.conf" ''
          monitor.alsa.rules = [
            {
              matches = [
                {
                  # Tu tarjeta de sonido (ajusta según tu hw)
                  node.name = "~alsa_output.*"
                }
              ]
              actions = {
                update-props = {
                  audio.format = "S32LE"
                  audio.rate = 48000
                  api.alsa.period-size = 256      # Match quantum
                  api.alsa.headroom = 256
                  api.alsa.disable-batch = true   # Reduce latencia
                  
                  # Deshabilitar suspend (CRÍTICO para gaming)
                  session.suspend-timeout-seconds = 0
                  
                  # Prioridad realtime
                  node.driver = true
                  priority.session = 1000
                }
              }
            }
          ]
          
          monitor.alsa.properties = {
            alsa.reserve = false                 # No bloquear la tarjeta
          }
        '')
      ];
    };
  };

  # ===== RTKIT =====
  security.rtkit.enable = true;
  
  # ===== LIMITE DE REALTIME PARA AUDIO =====
  security.pam.loginLimits = [
    { domain = "@users"; type = "soft"; item = "rtprio"; value = "99"; }
    { domain = "@users"; type = "hard"; item = "rtprio"; value = "99"; }
    { domain = "@users"; type = "soft"; item = "memlock"; value = "unlimited"; }
    { domain = "@users"; type = "hard"; item = "memlock"; value = "unlimited"; }
  ];

  # ===== PAQUETES =====
  environment.systemPackages = with pkgs; [
    pavucontrol
    pwvucontrol
    easyeffects
    helvum              # Patchbay gráfico para PipeWire
    qpwgraph            # Alternativa a Helvum
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
  
  # ===== DESHABILITAR TIMEOUT DE SUSPENSIÓN =====
  systemd.user.services.pipewire.serviceConfig = {
    Slice = "session.slice";
    LimitRTPRIO = 95;
    LimitMEMLOCK = "infinity";
  };
  
  systemd.user.services.wireplumber.serviceConfig = {
    Slice = "session.slice";
    LimitRTPRIO = 95;
  };
}
