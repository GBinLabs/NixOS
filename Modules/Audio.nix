# Modules/Audio.nix
{pkgs, ...}: {
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
        "default.clock.quantum" = 512;
        "default.clock.min-quantum" = 256;
        "default.clock.max-quantum" = 2048;
      };
      
      "context.modules" = [
        {
          name = "libpipewire-module-rt";
          args = {
            "nice.level" = -11;
            "rt.prio" = 88;
            "rt.time.soft" = 200000;
            "rt.time.hard" = 200000;
          };
          flags = ["ifexists" "nofail"];
        }
      ];
    };

    wireplumber = {
      enable = true;
      configPackages = [
        (pkgs.writeTextDir "share/wireplumber/wireplumber.conf.d/51-alsa-disable-dsp.conf" ''
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
  
  environment.systemPackages = with pkgs; [
    pavucontrol
    easyeffects
  ];
}
