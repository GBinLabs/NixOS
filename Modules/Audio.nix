{pkgs, ...}: {
  # ===== PIPEWIRE OPTIMIZADO =====
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # Configuración de baja latencia y alta calidad
    extraConfig.pipewire."context.properties" = {
      "default.clock.rate" = 48000;
      "default.clock.quantum" = 1024;
      "default.clock.min-quantum" = 32;
      "default.clock.max-quantum" = 2048;
      "default.clock.allowed-rates" = [44100 48000 96000];
    };

    # Configuración adicional para PipeWire Pulse
    extraConfig.pipewire-pulse = {
      "context.properties" = {
        "log.level" = 2;
      };
      "stream.properties" = {
        "node.latency" = "1024/48000";
        "resample.quality" = 10;
      };
    };

    # Configuración de WirePlumber
    wireplumber = {
      enable = true;

      # Configuraciones personalizadas de WirePlumber
      configPackages = [
        # Volumen persistente del micrófono
        (pkgs.writeTextDir "share/wireplumber/main.lua.d/51-mic-volume.lua" ''
          -- Ajustar volumen de micrófono automáticamente
          rule = {
            matches = {
              {
                { "node.name", "matches", "alsa_input.*" },
              },
            },
            apply_properties = {
              ["audio.format"] = "S16LE",
              ["audio.rate"] = 48000,
              ["api.alsa.period-size"] = 1024,
              ["api.alsa.headroom"] = 0,
              ["session.suspend-timeout-seconds"] = 0,  -- No suspender
            },
          }
          table.insert(alsa_monitor.rules, rule)
        '')

        # Mejorar calidad de Bluetooth (opcional)
        (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
          -- Mejorar calidad de Bluetooth
          bluez_monitor.properties = {
            ["bluez5.enable-sbc-xq"] = true,
            ["bluez5.enable-msbc"] = true,
            ["bluez5.enable-hw-volume"] = true,
            ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]",
          }
        '')
      ];
    };
  };

  # RTKit para audio en tiempo real
  security.rtkit.enable = true;

  # Paquetes útiles a nivel de sistema
  environment.systemPackages = with pkgs; [
    pavucontrol # Control de volumen GUI
    pwvucontrol # Control nativo de PipeWire
    wireplumber # CLI tools de WirePlumber
  ];

  # ===== SERVICIO DE MONITOREO DE VOLUMEN =====
  # Este servicio ajusta automáticamente el volumen del micrófono
  systemd.user.services.audio-volume-monitor = {
    description = "Monitor de volumen de audio";
    after = ["pipewire.service" "wireplumber.service"];
    wants = ["pipewire.service" "wireplumber.service"];
    partOf = ["graphical-session.target"];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      RestartSec = "3s";

      # Limitar reintentos
      StartLimitBurst = 5;
      StartLimitIntervalSec = 30;

      ExecStart = pkgs.writeShellScript "audio-volume-monitor" ''
        #!/usr/bin/env bash
        set -euo pipefail

        echo "Iniciando monitor de volumen de audio..."

        # Función para ajustar volumen
        adjust_volume() {
          local attempts=0
          local max_attempts=3

          while [ $attempts -lt $max_attempts ]; do
            if ${pkgs.wireplumber}/bin/wpctl set-volume @DEFAULT_SOURCE@ 0.3 2>/dev/null; then
              echo "✓ Volumen del micrófono ajustado a 30%"
              return 0
            fi

            attempts=$((attempts + 1))
            if [ $attempts -lt $max_attempts ]; then
              echo "⚠ Intento $attempts falló, reintentando..."
              sleep 1
            fi
          done

          echo "✗ No se pudo ajustar el volumen después de $max_attempts intentos"
          return 1
        }

        # Ajustar volumen al inicio
        sleep 2
        adjust_volume

        # Monitorear cambios en el sistema de audio
        ${pkgs.pipewire}/bin/pw-mon | while read -r line; do
          # Detectar cuando se agregan o cambian dispositivos de entrada
          if echo "$line" | grep -qE "added|changed"; then
            if echo "$line" | grep -qE "Audio/Source"; then
              echo "Cambio detectado en dispositivo de entrada, ajustando volumen..."
              sleep 1
              adjust_volume
            fi
          fi
        done
      '';
    };

    wantedBy = ["graphical-session.target"];
  };

  # ===== SERVICIO DE SINCRONIZACIÓN AUDIO-EASYEFFECTS =====
  # Este servicio se asegura de que EasyEffects se recargue cuando PipeWire se reinicie
  systemd.user.services.audio-easyeffects-sync = {
    description = "Sincronizar EasyEffects con cambios de PipeWire";
    after = [
      "pipewire.service"
      "wireplumber.service"
      "easyeffects.service"
    ];
    requires = ["pipewire.service"];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;

      ExecStart = pkgs.writeShellScript "sync-easyeffects" ''
        #!/usr/bin/env bash
        set -euo pipefail

        echo "Verificando estado de EasyEffects..."

        # Esperar a que PipeWire esté completamente listo
        sleep 3

        # Verificar si EasyEffects está corriendo
        if ${pkgs.procps}/bin/pgrep -x easyeffects >/dev/null 2>&1; then
          echo "EasyEffects está corriendo, recargando servicio..."
          ${pkgs.systemd}/bin/systemctl --user reload-or-restart easyeffects.service || true
        else
          echo "EasyEffects no está corriendo, iniciando..."
          ${pkgs.systemd}/bin/systemctl --user start easyeffects.service || true
        fi
      '';
    };
  };

  # ===== PATH WATCH PARA DETECTAR CAMBIOS EN PIPEWIRE =====
  # Este servicio se activa cuando PipeWire cambia de estado
  systemd.user.paths.pipewire-restart-detector = {
    pathConfig = {
      PathChanged = "%t/pipewire-0";
      PathModified = "%t/pipewire-0";
      Unit = "audio-easyeffects-sync.service";
    };

    wantedBy = ["default.target"];
  };
}
