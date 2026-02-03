{ pkgs, lib, ... }:
{
  services.languagetool = {
    enable = true;
    package = pkgs.languagetool;
    port = 8081;
    public = false;

    # ═══════════════════════════════════════════════════════════════════════════
    # OPCIONES DE JVM - Optimizadas para 8GB RAM
    # ═══════════════════════════════════════════════════════════════════════════
    # Con 8GB totales, reservamos ~1.5GB para LanguageTool
    # Esto deja suficiente para VS Code (~1-2GB) y el sistema (~2-3GB)
    jvmOptions = [
      # Memoria
      "-Xms256m"          # Inicio conservador
      "-Xmx1536m"         # Máximo 1.5GB (reducido de 2GB)
      
      # Garbage Collector - G1 con pausas cortas
      "-XX:+UseG1GC"
      "-XX:MaxGCPauseMillis=100"
      "-XX:G1HeapRegionSize=4m"
      
      # Optimizaciones de memoria
      "-XX:+UseStringDeduplication"
      "-XX:StringDeduplicationAgeThreshold=3"
      
      # Reducir overhead de metadatos
      "-XX:MaxMetaspaceSize=128m"
      "-XX:CompressedClassSpaceSize=64m"
      
      # Deshabilitar JIT agresivo (reduce uso de CPU)
      "-XX:TieredStopAtLevel=1"
      "-XX:CICompilerCount=1"
    ];

    allowOrigin = null;

    settings = {
      # ═══════════════════════════════════════════════════════════════════════
      # CACHE - Reducido para menor uso de RAM
      # ═══════════════════════════════════════════════════════════════════════
      cacheSize = 2000;  # Reducido de 5000
      
      # Precalentamiento deshabilitado para inicio más rápido
      pipelinePrewarming = false;

      # ═══════════════════════════════════════════════════════════════════════
      # N-GRAM DATA - Solo español para ahorrar espacio
      # ═══════════════════════════════════════════════════════════════════════
      # Los n-gramas mejoran detección de errores contextuales.
      # Solo se incluye español (~3GB) para optimizar uso de disco.
      languageModel = pkgs.linkFarm "languageModel" (
        builtins.mapAttrs (_: v: pkgs.fetchzip v) {
          es = {
            url = "https://languagetool.org/download/ngram-data/ngrams-es-20150915.zip";
            hash = "sha256-z+JJe8MeI9YXE2wUA2acK9SuQrMZ330QZCF9e234FCk=";
          };
          # Inglés deshabilitado para ahorrar ~15GB de espacio en disco
          # Descomentar si es necesario:
          en = {
             url = "https://languagetool.org/download/ngram-data/ngrams-en-20150817.zip";
             hash = "sha256-v3Ym6CBJftQCY5FuY6s5ziFvHKAyYD3fTHr99i6N8sE=";
          };
        }
      );

      # ═══════════════════════════════════════════════════════════════════════
      # FASTTEXT - Detección de idioma
      # ═══════════════════════════════════════════════════════════════════════
      fasttextBinary = "${pkgs.fasttext}/bin/fasttext";
      fasttextModel = pkgs.fetchurl {
        name = "lid.176.bin";
        url = "https://dl.fbaipublicfiles.com/fasttext/supervised-models/lid.176.bin";
        hash = "sha256-fmnsVFG8JhzHhE5J5HkqhdfwnAZ4nsgA/EpErsNidk4=";
      };

      # ═══════════════════════════════════════════════════════════════════════
      # LÍMITES - Ajustados para hardware limitado
      # ═══════════════════════════════════════════════════════════════════════
      # Tamaño máximo por solicitud (caracteres)
      # 100K caracteres ≈ 50 páginas de texto denso
      maxTextLength = 100000;  # Reducido de 200000
      
      # Timeout más largo para compensar CPU lento
      maxCheckTimeMillis = 180000;  # 3 minutos
      
      # Solo 2 hilos (el N4020 tiene 2 núcleos)
      maxCheckThreads = 2;
      
      # Limitar sugerencias
      maxSpellingSuggestions = 3;  # Reducido de 5

      prometheusMonitoring = false;
    };
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SYSTEMD - Configuración del servicio
  # ═══════════════════════════════════════════════════════════════════════════
  systemd.services.languagetool = {
    serviceConfig = {
      # Reinicio automático
      Restart = "on-failure";
      RestartSec = "10s";
      
      # Límites de recursos para evitar que monopolice el sistema
      MemoryMax = "2G";
      MemoryHigh = "1700M";
      CPUQuota = "150%";  # Máximo 1.5 núcleos
      
      # Prioridad baja para no interferir con VS Code
      Nice = 10;
      IOSchedulingClass = "idle";
    };
    
    # Iniciar después del login para no ralentizar el arranque
    wantedBy = lib.mkForce [ "default.target" ];
  };
}
