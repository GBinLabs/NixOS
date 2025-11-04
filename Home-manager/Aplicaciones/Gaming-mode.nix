# Home-manager/Aplicaciones/Gaming/gaming-mode.nix
{ pkgs, ... }: {
  home.packages = [
    (pkgs.writeShellScriptBin "gaming-mode" ''
      #!/usr/bin/env bash
      
      echo "🎮 Activando modo gaming..."
      
      # CPU performance governor
      sudo cpupower frequency-set -g performance
      
      # GPU high performance
      for card in /sys/class/drm/card*/device/power_dpm_force_performance_level; do
        echo "high" | sudo tee "$card" > /dev/null
      done
      
      # Deshabilitar compositor (si aplica)
      # hyprctl keyword decoration:blur:enabled false
      
      # Kill procesos innecesarios
      killall -9 baobab gnome-text-editor 2>/dev/null || true
      
      # Network optimizations
      sudo sysctl -w net.ipv4.tcp_congestion_control=bbr
      
      echo "✅ Modo gaming activado"
      echo "Ejecuta: gaming-mode-off para desactivar"
    '')
    
    (pkgs.writeShellScriptBin "gaming-mode-off" ''
      #!/usr/bin/env bash
      
      echo "🔄 Desactivando modo gaming..."
      
      # CPU schedutil governor
      sudo cpupower frequency-set -g schedutil
      
      # GPU auto mode
      for card in /sys/class/drm/card*/device/power_dpm_force_performance_level; do
        echo "auto" | sudo tee "$card" > /dev/null
      done
      
      echo "✅ Modo normal restaurado"
    '')
  ];
}
