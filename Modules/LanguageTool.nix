{ pkgs, lib, ... }:
{
  services.languagetool = {
    enable = true;
    package = pkgs.languagetool;
    port = 8081;
    public = false; # Solo acceso local (más seguro)

    # Java moderno con mejor rendimiento
    jrePackage = pkgs.temurin-bin-21;

    # Optimización de memoria para archivos grandes
    # Ajustar según tu RAM disponible:
    # - 8GB RAM sistema: usar "-Xmx2g"
    # - 16GB RAM sistema: usar "-Xmx4g"
    # - 32GB+ RAM sistema: usar "-Xmx8g"
    jvmOptions = [
      "-Xms512m" # Memoria inicial
      "-Xmx2g" # Memoria máxima (ajustar según tu sistema)
      "-XX:+UseG1GC" # Garbage collector optimizado
      "-XX:+UseStringDeduplication" # Reduce uso de memoria
      "-XX:MaxGCPauseMillis=200" # Limita pausas del GC
    ];

    # Permitir acceso desde extensiones de navegador (opcional)
    # Usar null para máxima seguridad, o "" para permitir todo
    allowOrigin = null;

    settings = {
      # ═══════════════════════════════════════════════════════════════
      # CACHE - Crítico para archivos grandes
      # ═══════════════════════════════════════════════════════════════
      # Número de oraciones cacheadas (evita re-análisis)
      # Para archivos grandes: usar 5000-10000
      cacheSize = 5000;

      # Pre-calentar el pipeline al iniciar (reduce latencia inicial)
      pipelinePrewarming = true;

      # ═══════════════════════════════════════════════════════════════
      # N-GRAM DATA - Detecta errores contextuales
      # ═══════════════════════════════════════════════════════════════
      # Detecta confusiones como "their/there", "haber/a ver", etc.
      # IMPORTANTE: Requiere ~3GB de espacio en disco para español
      # Los datos se descargan automáticamente y se cachean en /nix/store
      languageModel = pkgs.linkFarm "languageModel" (
        builtins.mapAttrs (_: v: pkgs.fetchzip v) {
          # Español - 3.1GB (esencial para tu libro)
          es = {
            url = "https://languagetool.org/download/ngram-data/ngrams-es-20150915.zip";
            hash = "sha256-z+JJe8MeI9YXE2wUA2acK9SuQrMZ330QZCF9e234FCk=";
          };
          # Inglés - 15GB (opcional, descomentar si lo necesitas)
           en = {
             url = "https://languagetool.org/download/ngram-data/ngrams-en-20150817.zip";
             hash = "sha256-v3Ym6CBJftQCY5FuY6s5ziFvHKAyYD3fTHr99i6N8sE=";
           };
        }
      );

      # ═══════════════════════════════════════════════════════════════
      # NOTA SOBRE WORD2VEC
      # ═══════════════════════════════════════════════════════════════
      # Las opciones word2vec y neuralnetwork fueron DEPRECADAS y
      # ELIMINADAS de LanguageTool. Ya no están disponibles.
      # Los n-gramas proporcionan funcionalidad similar.

      # ═══════════════════════════════════════════════════════════════
      # FASTTEXT - Detección automática de idioma
      # ═══════════════════════════════════════════════════════════════
      # Detecta el idioma automáticamente (útil para documentos mixtos)
      fasttextBinary = "${pkgs.fasttext}/bin/fasttext";
      fasttextModel = pkgs.fetchurl {
        name = "lid.176.bin";
        url = "https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin";
        hash = "sha256-fmnsVFG8JhzHhE5J5HkqhdfwnAZ4nsgA/EpErsNidk4=";
      };

      # ═══════════════════════════════════════════════════════════════
      # LÍMITES Y RENDIMIENTO
      # ═══════════════════════════════════════════════════════════════
      # Tamaño máximo de texto por solicitud (en caracteres)
      # Para archivos muy grandes, aumentar este valor
      # Default: 50000, para libros usar 150000-500000
      maxTextLength = 200000;

      # Tiempo máximo de verificación por solicitud (milisegundos)
      # Para archivos grandes: 60000-120000 (1-2 minutos)
      maxCheckTimeMillis = 120000;

      # Hilos de trabajo paralelos
      # Ajustar según núcleos de CPU disponibles
      maxCheckThreads = 4;

      # Límite de sugerencias ortográficas (mejora rendimiento)
      maxSpellingSuggestions = 5;

      # ═══════════════════════════════════════════════════════════════
      # MONITOREO (opcional)
      # ═══════════════════════════════════════════════════════════════
      prometheusMonitoring = false;
      # prometheusPort = 9301;
    };
  };

  # Asegurar que el servicio se reinicie automáticamente si falla
  systemd.services.languagetool = {
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
