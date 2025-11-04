# Modules/Audio.nix
{ pkgs, ... }: {
  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };
    pulse.enable = true;
    jack.enable = true;

    extraConfig.pipewire."92-low-latency" = {
      "context.properties" = {
        "default.clock.rate" = 48000;
        "default.clock.quantum" = 256;
        "default.clock.min-quantum" = 32;
        "default.clock.max-quantum" = 2048;
        "default.clock.force-quantum" = 0;
        "default.clock.force-rate" = 0;
      };
      
      "context.modules" = [
        {
          name = "libpipewire-module-rt";
          args = {
            "nice.level" = -20;
            "rt.prio" = 95;
            "rt.time.soft" = 2000000;
            "rt.time.hard" = 2000000;
          };
          flags = [ "ifexists" "nofail" ];
        }
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            "server.address" = [ "unix:native" ];
            "pulse.min.req" = "256/48000";
            "pulse.min.quantum" = "256/48000";
            "pulse.max.quantum" = "256/48000";
            "pulse.min.frag" = "256/48000";
            "pulse.default.frag" = "256/48000";
            "pulse.max.frag" = "256/48000";
          };
        }
      ];
    };

    extraConfig.pipewire-pulse."92-low-latency" = {
      "pulse.properties" = {
        "pulse.min.req" = "256/48000";
        "pulse.default.req" = "256/48000";
        "pulse.max.req" = "256/48000";
        "pulse.min.quantum" = "256/48000";
        "pulse.max.quantum" = "256/48000";
      };
      
      "stream.properties" = {
        "node.latency" = "256/48000";
        "resample.quality" = 10;
        "resample.disable" = false;
        "channelmix.normalize" = true;
        "channelmix.mix-lfe" = true;
        "node.pause-on-idle" = false;
        "session.suspend-timeout-seconds" = 0;
      };
      
      "pulse.rules" = [
        {
          matches = [
            { "application.process.binary" = "cs2"; }
            { "application.process.binary" = "csgo"; }
            { "application.name" = "VALORANT"; }
          ];
          actions = {
            update-props = {
              "node.latency" = "128/48000";
              "pulse.min.quantum" = "128/48000";
              "pulse.max.quantum" = "128/48000";
              "node.pause-on-idle" = false;
              "session.suspend-timeout-seconds" = 0;
            };
          };
        }
        {
          matches = [
            { "application.name" = "Discord"; }
            { "application.name" = "vesktop"; }
          ];
          actions = {
            update-props = {
              "node.latency" = "512/48000";
              "pulse.min.quantum" = "512/48000";
            };
          };
        }
      ];
    };

    wireplumber = {
      enable = true;
      
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/99-gaming.conf" ''
          monitor.alsa.rules = [
            {
              matches = [
                { node.name = "~alsa_output.*" }
              ]
              actions = {
                update-props = {
                  audio.format = "S32LE"
                  audio.rate = 48000
                  audio.allowed-rates = [ 44100 48000 88200 96000 ]
                  api.alsa.period-size = 256
                  api.alsa.headroom = 256
                  api.alsa.disable-batch = true
                  api.alsa.use-chmap = false
                  
                  session.suspend-timeout-seconds = 0
                  
                  node.driver = true
                  priority.session = 1000
                  priority.driver = 1000
                }
              }
            }
          ]
          
          monitor.alsa.properties = {
            alsa.reserve = false
          }
        '')
      ];
    };
  };

  security.rtkit.enable = true;
  
  security.pam.loginLimits = [
    { domain = "@users"; type = "soft"; item = "rtprio"; value = "99"; }
    { domain = "@users"; type = "hard"; item = "rtprio"; value = "99"; }
    { domain = "@users"; type = "soft"; item = "memlock"; value = "unlimited"; }
    { domain = "@users"; type = "hard"; item = "memlock"; value = "unlimited"; }
  ];

  environment.systemPackages = with pkgs; [
    pavucontrol
    pwvucontrol
    easyeffects
    helvum
    qpwgraph
  ];

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
