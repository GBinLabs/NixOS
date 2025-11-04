# Modules/Ananicy-CPP.nix
# Priorización automática de procesos para GAMING GENERAL
# Funciona con TODOS los juegos (Steam, Lutris, Wine, etc.)

{ config, pkgs, lib, ... }: {
  options.Ananicy-CPP.enable = lib.mkEnableOption "Habilitar Ananicy-CPP";

  config = lib.mkIf config.Ananicy-CPP.enable {
    
    environment.systemPackages = with pkgs; [
      ananicy-cpp
    ];

    systemd.services.ananicy-cpp = {
      description = "Ananicy-CPP - Auto nice daemon";
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.ananicy-cpp}/bin/ananicy-cpp";
        Restart = "on-failure";
        RestartSec = 5;
        
        Nice = -20;
        IOSchedulingClass = "realtime";
        IOSchedulingPriority = 0;
        
        NoNewPrivileges = false;
        PrivateTmp = true;
        ProtectSystem = "strict";
        ProtectHome = true;
        ReadWritePaths = [ "/proc" "/sys" ];
      };
    };

    # ===== REGLAS GENERALES PARA GAMING =====
    environment.etc."ananicy.d/00-gaming.rules".text = ''
      # ===== STEAM Y JUEGOS =====
      # Todos los procesos de Steam con extensiones comunes de juegos
      { "name": "steam", "type": "Game", "nice": -5, "ioclass": "best-effort", "ionice": 2 }
      { "name": "steamwebhelper", "type": "BG_CPUIO", "nice": 10, "ioclass": "idle" }
      { "name": "gameoverlayui", "type": "Game", "nice": -5, "ioclass": "best-effort", "ionice": 1 }
      
      # Procesos de juegos genéricos (extensiones .exe, .x86_64, etc.)
      { "name": "*.exe", "type": "Game", "nice": -10, "ioclass": "realtime", "ionice": 0, "sched": "rr", "oom_score_adj": -1000 }
      { "name": "*.x86_64", "type": "Game", "nice": -10, "ioclass": "realtime", "ionice": 0, "sched": "rr", "oom_score_adj": -1000 }
      { "name": "*-bin", "type": "Game", "nice": -10, "ioclass": "realtime", "ionice": 0, "sched": "rr", "oom_score_adj": -1000 }
      
      # ===== WINE / PROTON =====
      { "name": "wine64-preloader", "type": "Game", "nice": -10, "ioclass": "realtime", "ionice": 0, "sched": "rr" }
      { "name": "wine-preloader", "type": "Game", "nice": -10, "ioclass": "realtime", "ionice": 0, "sched": "rr" }
      { "name": "wineserver", "type": "Game", "nice": -8, "ioclass": "realtime", "ionice": 1 }
      
      # ===== LAUNCHERS =====
      { "name": "lutris", "type": "Game", "nice": 0, "ioclass": "best-effort", "ionice": 2 }
      { "name": "heroic", "type": "Game", "nice": 0, "ioclass": "best-effort", "ionice": 2 }
      { "name": "prismlauncher", "type": "Game", "nice": 0, "ioclass": "best-effort", "ionice": 2 }
      { "name": "legendary", "type": "Game", "nice": 0, "ioclass": "best-effort", "ionice": 2 }
      
      # ===== MINECRAFT (ejemplo de juego nativo) =====
      { "name": "java", "type": "Game", "nice": -5, "ioclass": "best-effort", "ionice": 2 }
      
      # ===== EMULADORES =====
      { "name": "dolphin-emu", "type": "Game", "nice": -8, "ioclass": "realtime", "ionice": 1 }
      { "name": "rpcs3", "type": "Game", "nice": -8, "ioclass": "realtime", "ionice": 1 }
      { "name": "yuzu", "type": "Game", "nice": -8, "ioclass": "realtime", "ionice": 1 }
      { "name": "cemu", "type": "Game", "nice": -8, "ioclass": "realtime", "ionice": 1 }
      
      # ===== APLICACIONES DE COMUNICACIÓN (prioridad media) =====
      { "name": "Discord", "type": "Media", "nice": -2, "ioclass": "best-effort", "ionice": 2 }
      { "name": "discord", "type": "Media", "nice": -2, "ioclass": "best-effort", "ionice": 2 }
      { "name": "vesktop", "type": "Media", "nice": -2, "ioclass": "best-effort", "ionice": 2 }
      { "name": "teamspeak", "type": "Media", "nice": -2, "ioclass": "best-effort", "ionice": 2 }
      { "name": "mumble", "type": "Media", "nice": -2, "ioclass": "best-effort", "ionice": 2 }
      
      # ===== NAVEGADORES (baja prioridad cuando juegas) =====
      { "name": "firefox", "type": "BG_CPUIO", "nice": 5, "ioclass": "best-effort", "ionice": 4 }
      { "name": "Web Content", "type": "BG_CPUIO", "nice": 10, "ioclass": "best-effort", "ionice": 5 }
      { "name": "chromium", "type": "BG_CPUIO", "nice": 5, "ioclass": "best-effort", "ionice": 4 }
      { "name": "chrome", "type": "BG_CPUIO", "nice": 5, "ioclass": "best-effort", "ionice": 4 }
      
      # ===== HYPRLAND Y COMPOSITOR (mantener responsive) =====
      { "name": "Hyprland", "type": "LowLatency_RT", "nice": -10, "ioclass": "realtime", "ionice": 0, "sched": "rr" }
      { "name": "waybar", "type": "LowLatency_RT", "nice": -5, "ioclass": "best-effort", "ionice": 1 }
      { "name": "rofi", "type": "LowLatency_RT", "nice": -5, "ioclass": "best-effort", "ionice": 1 }
      
      # ===== AUDIO (máxima prioridad) =====
      { "name": "pipewire", "type": "LowLatency_RT", "nice": -20, "ioclass": "realtime", "ionice": 0, "sched": "rr", "oom_score_adj": -1000 }
      { "name": "wireplumber", "type": "LowLatency_RT", "nice": -15, "ioclass": "realtime", "ionice": 0, "sched": "rr" }
      
      # ===== COMPILADORES Y BUILD TOOLS (muy baja prioridad) =====
      { "name": "gcc", "type": "BG_CPUIO", "nice": 19, "ioclass": "idle" }
      { "name": "g++", "type": "BG_CPUIO", "nice": 19, "ioclass": "idle" }
      { "name": "clang", "type": "BG_CPUIO", "nice": 19, "ioclass": "idle" }
      { "name": "rustc", "type": "BG_CPUIO", "nice": 19, "ioclass": "idle" }
      { "name": "cargo", "type": "BG_CPUIO", "nice": 19, "ioclass": "idle" }
      { "name": "ninja", "type": "BG_CPUIO", "nice": 19, "ioclass": "idle" }
      { "name": "make", "type": "BG_CPUIO", "nice": 19, "ioclass": "idle" }
      
      # ===== TORRENTS / DESCARGAS (baja prioridad) =====
      { "name": "transmission", "type": "BG_CPUIO", "nice": 15, "ioclass": "idle" }
      { "name": "qbittorrent", "type": "BG_CPUIO", "nice": 15, "ioclass": "idle" }
      { "name": "aria2c", "type": "BG_CPUIO", "nice": 15, "ioclass": "idle" }
      
      # ===== SYSTEM SERVICES (baja prioridad) =====
      { "name": "systemd-journal", "type": "BG_CPUIO", "nice": 19, "ioclass": "idle" }
      { "name": "systemd-udevd", "type": "BG_CPUIO", "nice": 10, "ioclass": "best-effort", "ionice": 5 }
    '';

    # ===== TIPOS DE PROCESOS =====
    environment.etc."ananicy.d/00-types.types".text = ''
      { "type": "Game", "nice": -10, "ioclass": "realtime", "ionice": 0, "sched": "rr" }
      { "type": "LowLatency_RT", "nice": -10, "ioclass": "realtime", "ionice": 0, "sched": "rr" }
      { "type": "Media", "nice": -2, "ioclass": "best-effort", "ionice": 2, "sched": "rr" }
      { "type": "BG_CPUIO", "nice": 15, "ioclass": "idle", "ionice": 7 }
    '';

    # ===== CONFIGURACIÓN =====
    environment.etc."ananicy.d/ananicy.conf".text = ''
      # Frecuencia de chequeo (cada 5 segundos)
      check_freq=5
      
      # Aplicar a procesos hijos
      apply_nice_to_children=true
      apply_ioclass_to_children=true
      apply_ionice_to_children=true
      apply_sched_to_children=true
      
      # Logging mínimo
      log_level=warn
      log_applied_rule=false
      
      # OOM score
      apply_oom_score_adj=true
      
      # CGroups
      cgroup_load=true
      type_load=true
      rule_load=true
    '';
  };
}
