{
  pkgs,
  lib,
  ...
}: let
  # Presets por defecto a cargar al inicio
  defaultInputPreset = "Voice";
  defaultOutputPreset = "Audio";

  # Script para cargar presets de forma confiable
  loadPresetsScript = pkgs.writeShellScript "load-easyeffects-presets" ''
    #!/usr/bin/env bash
    set -euo pipefail

    # Esperar a que EasyEffects esté completamente listo
    sleep 3

    # Función para intentar cargar preset con reintentos
    load_preset() {
      local preset_name="$1"
      local preset_type="$2"  # "input" o "output"
      local max_attempts=5
      local attempt=1

      while [ $attempt -le $max_attempts ]; do
        echo "Intento $attempt de $max_attempts: Cargando preset $preset_type: $preset_name"

        if ${pkgs.easyeffects}/bin/easyeffects --load-preset "$preset_name" 2>/dev/null; then
          echo "✓ Preset $preset_type '$preset_name' cargado exitosamente"
          return 0
        fi

        echo "⚠ Intento $attempt falló, reintentando en 2 segundos..."
        sleep 2
        attempt=$((attempt + 1))
      done

      echo "✗ Error: No se pudo cargar preset $preset_type '$preset_name' después de $max_attempts intentos"
      return 1
    }

    # Cargar preset de input
    load_preset "${defaultInputPreset}" "input"

    # Cargar preset de output
    load_preset "${defaultOutputPreset}" "output"

    echo "✓ Todos los presets cargados correctamente"
  '';

  # Script monitor MEJORADO con cooldown para evitar loops
  monitorScript = pkgs.writeShellScript "easyeffects-monitor" ''
    #!/usr/bin/env bash
    set -euo pipefail

    echo "Iniciando monitor de EasyEffects..."

    # Variables para cooldown
    last_reload=0
    cooldown=10  # 10 segundos de cooldown entre recargas

    # Monitorear eventos de PipeWire
    ${pkgs.pipewire}/bin/pw-mon | while read -r line; do
      # Obtener tiempo actual
      current_time=$(date +%s)
      time_diff=$((current_time - last_reload))

      # Solo procesar si han pasado más de 10 segundos desde la última recarga
      if [ $time_diff -lt $cooldown ]; then
        continue
      fi

      # SOLO detectar cuando se AGREGAN dispositivos (no cambios)
      if echo "$line" | grep -q "added"; then
        # Solo dispositivos de audio específicos (NO detectar "node" genérico)
        if echo "$line" | grep -qE "Audio/Source|Audio/Sink"; then
          echo "Nuevo dispositivo de audio detectado, recargando presets en 3 segundos..."
          sleep 3
          ${loadPresetsScript}
          last_reload=$(date +%s)
        fi
      fi
    done
  '';
in {
  # Copiar presets personalizados desde archivos JSON
  # CRÍTICO: Los nombres de archivo DEBEN coincidir con los nombres de preset
  home.file = {
    # INPUT PRESET - Nombre debe coincidir con defaultInputPreset
    ".config/easyeffects/input/Voice.json" = {
      source = ./Presets/Voice.json;
    };

    # OUTPUT PRESET - Nombre debe coincidir con defaultOutputPreset
    ".config/easyeffects/output/Audio.json" = {
      source = ./Presets/Audio.json;
    };

    # Puedes añadir más presets aquí
    # ".config/easyeffects/output/Music.json" = {
    #   source = ./Presets/Music.json;
    # };
  };

  # Configuración principal de EasyEffects
  xdg.configFile."easyeffects/easyeffects.conf".text = lib.generators.toINI {} {
    global = {
      # Procesar todos los dispositivos automáticamente
      process-all-inputs = true;
      process-all-outputs = true;

      # Tema oscuro
      use-dark-theme = true;

      # No cerrar al minimizar
      shutdown-on-window-close = false;

      # Calidad de procesamiento
      priority-type = "Realtime";

      # Buffer size (menor = menor latencia, mayor CPU)
      buffer-out = 1024;
      buffer-in = 1024;

      # Reintentar conexión si falla
      autoreconnect = true;
    };

    streamoutputs = {
      # Lista de plugins para salida (output)
      # Ajusta según tu preset de output
      plugins = "[]";
    };

    streaminputs = {
      # Lista de plugins para entrada (input)
      # Ajusta según tu preset de input
      plugins = ''["rnnoise#0","gate#0","deesser#0","compressor#0","equalizer#0","limiter#0"]'';
    };
  };

  # ===== SERVICIO PRINCIPAL DE EASYEFFECTS =====
  systemd.user.services.easyeffects = {
    Unit = {
      Description = "EasyEffects - Audio Effects for PipeWire";
      Documentation = "https://github.com/wwmm/easyeffects";
      After = [
        "pipewire.service"
        "pipewire-pulse.service"
        "wireplumber.service"
      ];
      # Vinculado a PipeWire pero no se detiene cuando PipeWire se reinicia
      Wants = ["pipewire.service"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "dbus";
      BusName = "com.github.wwmm.easyeffects";

      # Iniciar EasyEffects como servicio D-Bus
      ExecStart = "${pkgs.easyeffects}/bin/easyeffects --gapplication-service";

      # CRÍTICO: Cargar presets al inicio
      ExecStartPost = loadPresetsScript;

      # NUEVO: Recargar presets cuando el servicio se recarga (ej: después de nixos-rebuild)
      ExecReload = loadPresetsScript;

      # Reiniciar si falla
      Restart = "on-failure";
      RestartSec = "5s";

      # Limitar reintentos
      StartLimitBurst = 5;
      StartLimitIntervalSec = 30;

      # Variables de entorno
      Environment = [
        "G_MESSAGES_DEBUG=none"
      ];

      # Slice para mejor gestión de recursos
      Slice = "session.slice";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };

  # ===== SERVICIO MONITOR PARA RECARGAR PRESETS AUTOMÁTICAMENTE =====
  # Este monitor SOLO detecta cuando se AGREGAN dispositivos nuevos (no cambios)
  systemd.user.services.easyeffects-preset-monitor = {
    Unit = {
      Description = "Monitor para recargar presets de EasyEffects automáticamente";
      After = [
        "easyeffects.service"
        "pipewire.service"
        "wireplumber.service"
      ];
      # QUITADO: Requires y PartOf que causaban el loop
    };

    Service = {
      Type = "simple";
      ExecStart = monitorScript;

      # Reiniciar SOLO si falla (no siempre)
      Restart = "on-failure";
      RestartSec = "10s";

      # Limitar reintentos
      StartLimitBurst = 3;
      StartLimitIntervalSec = 60;
    };

    Install = {
      WantedBy = ["default.target"];
    };
  };

  # ===== TIMER PARA VERIFICACIÓN PERIÓDICA (DESACTIVADO POR DEFECTO) =====
  # Descomenta esto SOLO si necesitas un respaldo adicional
  # El monitor debería ser suficiente

  # systemd.user.timers.easyeffects-preset-reload = {
  #   Unit = {
  #     Description = "Timer para verificar y recargar presets de EasyEffects";
  #   };
  #
  #   Timer = {
  #     OnBootSec = "30s";          # 30 segundos después del boot
  #     OnUnitActiveSec = "60s";    # Cada 60 segundos (no 30)
  #   };
  #
  #   Install = {
  #     WantedBy = ["timers.target"];
  #   };
  # };
  #
  # systemd.user.services.easyeffects-preset-reload = {
  #   Unit = {
  #     Description = "Recargar presets de EasyEffects";
  #   };
  #
  #   Service = {
  #     Type = "oneshot";
  #     ExecStart = loadPresetsScript;
  #     # No fallar si EasyEffects no está corriendo
  #     ExecStartPre = "${pkgs.bash}/bin/bash -c '${pkgs.procps}/bin/pgrep -x easyeffects >/dev/null || exit 0'";
  #   };
  # };

  # Script CLI para cambiar presets manualmente
  home.packages = with pkgs; [
    easyeffects
    # Comando para recargar presets manualmente
    (pkgs.writeShellScriptBin "ee-reload" ''
      #!/usr/bin/env bash
      echo "Recargando presets de EasyEffects..."
      ${loadPresetsScript}
    '')

    # Comando para listar y cargar presets
    (pkgs.writeShellScriptBin "ee-preset" ''
      #!/usr/bin/env bash

      INPUT_DIR="$HOME/.config/easyeffects/input"
      OUTPUT_DIR="$HOME/.config/easyeffects/output"

      if [ $# -eq 0 ]; then
        echo "📁 Presets de INPUT disponibles:"
        ls -1 "$INPUT_DIR" 2>/dev/null | sed 's/.json$//' | sed 's/^/  - /' || echo "  (ninguno)"
        echo ""
        echo "📁 Presets de OUTPUT disponibles:"
        ls -1 "$OUTPUT_DIR" 2>/dev/null | sed 's/.json$//' | sed 's/^/  - /' || echo "  (ninguno)"
        echo ""
        echo "Uso: ee-preset <nombre-del-preset>"
        echo "Ejemplo: ee-preset Voice"
        exit 0
      fi

      PRESET_NAME="$1"

      # Buscar en input
      if [ -f "$INPUT_DIR/$PRESET_NAME.json" ]; then
        ${pkgs.easyeffects}/bin/easyeffects --load-preset "$PRESET_NAME"
        echo "✓ Preset INPUT '$PRESET_NAME' cargado"
        exit 0
      fi

      # Buscar en output
      if [ -f "$OUTPUT_DIR/$PRESET_NAME.json" ]; then
        ${pkgs.easyeffects}/bin/easyeffects --load-preset "$PRESET_NAME"
        echo "✓ Preset OUTPUT '$PRESET_NAME' cargado"
        exit 0
      fi

      echo "✗ Preset '$PRESET_NAME' no encontrado"
      echo ""
      echo "Presets disponibles:"
      echo "INPUT:"
      ls -1 "$INPUT_DIR" 2>/dev/null | sed 's/.json$//' | sed 's/^/  - /' || echo "  (ninguno)"
      echo "OUTPUT:"
      ls -1 "$OUTPUT_DIR" 2>/dev/null | sed 's/.json$//' | sed 's/^/  - /' || echo "  (ninguno)"
      exit 1
    '')
  ];
}
