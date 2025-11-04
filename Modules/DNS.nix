# Modules/DNS-Smart.nix
# DNS inteligente que se desactiva en redes universitarias
# Detecta "BAR DIK" y "UNT" y usa DNS del router en esas redes

{ config, pkgs, lib, ... }: {
  options.DNS-Smart.enable = lib.mkEnableOption "DNS inteligente con detección de red universitaria";

  config = lib.mkIf config.DNS-Smart.enable {
    
    # ===== CONFIGURACIÓN BASE =====
    networking = {
      # NetworkManager dispatcher para cambiar DNS según la red
      networkmanager = {
        enable = true;
        
        # Script dispatcher que se ejecuta al conectar/desconectar
        dispatcherScripts = [
          {
            source = pkgs.writeShellScript "dns-switcher" ''
              #!/usr/bin/env bash
              
              # Variables
              INTERFACE="$1"
              ACTION="$2"
              SSID="$CONNECTION_ID"
              
              # Log
              logger "DNS-Switcher: Interface=$INTERFACE Action=$ACTION SSID=$SSID"
              
              # Solo actuar en conexiones UP
              if [ "$ACTION" != "up" ]; then
                exit 0
              fi
              
              # Detectar si es red universitaria
              if [[ "$SSID" == "BAR DIK" ]] || [[ "$SSID" == "UNT" ]]; then
                logger "DNS-Switcher: Red universitaria detectada ($SSID) - Usando DNS del router"
                
                # Desactivar DNS custom (usar DHCP)
                ${pkgs.systemd}/bin/resolvectl dns "$INTERFACE" ""
                ${pkgs.systemd}/bin/resolvectl domain "$INTERFACE" ""
                ${pkgs.systemd}/bin/resolvectl dnssec "$INTERFACE" no
                ${pkgs.systemd}/bin/resolvectl dnsovertls "$INTERFACE" no
                
                # Notificación
                ${pkgs.libnotify}/bin/notify-send "DNS" "Usando DNS de la universidad" -u low -t 2000 || true
              else
                logger "DNS-Switcher: Red externa - Activando DNS seguras (AdGuard)"
                
                # Activar DNS custom (AdGuard Family)
                ${pkgs.systemd}/bin/resolvectl dns "$INTERFACE" 94.140.14.14 94.140.15.15
                ${pkgs.systemd}/bin/resolvectl domain "$INTERFACE" "~."
                ${pkgs.systemd}/bin/resolvectl dnssec "$INTERFACE" yes
                ${pkgs.systemd}/bin/resolvectl dnsovertls "$INTERFACE" yes
                
                # Notificación
                ${pkgs.libnotify}/bin/notify-send "DNS" "DNS seguras activadas (AdGuard)" -u low -t 2000 || true
              fi
            '';
            type = "basic";
          }
        ];
      };
    };

    # ===== SYSTEMD-RESOLVED =====
    services.resolved = {
      enable = true;
      dnssec = "allow-downgrade";  # Flexible para redes universitarias
      domains = [ "~." ];
      
      # DNS por defecto (AdGuard Family Protection)
      # Se sobrescriben automáticamente en redes universitarias
      fallbackDns = [
        "94.140.14.14"  # AdGuard Family Primary
        "94.140.15.15"  # AdGuard Family Secondary
      ];
      
      # DNS-over-TLS (se desactiva en universidad)
      dnsovertls = "opportunistic";
      
      extraConfig = ''
        DNS=94.140.14.14#dns.adguard.com 94.140.15.15#dns.adguard.com
        DNSOverTLS=opportunistic
        DNSSEC=allow-downgrade
        MulticastDNS=no
        LLMNR=no
        Cache=yes
        CacheFromLocalhost=no
      '';
    };

    # ===== DESHABILITAR DNS ESTÁTICAS EN dhcpcd =====
    # Para que NetworkManager tenga control total
    networking.dhcpcd.extraConfig = ''
      # Permitir que NetworkManager gestione DNS
      nohook resolv.conf
    '';

    # ===== SCRIPT MANUAL PARA TESTEAR =====
    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "dns-status" ''
        #!/usr/bin/env bash
        echo "=== Estado de DNS ==="
        echo ""
        echo "Red actual:"
        nmcli -t -f active,ssid dev wifi | grep '^yes' | cut -d: -f2
        echo ""
        echo "DNS activas:"
        resolvectl status | grep "DNS Servers" -A 2
        echo ""
        echo "DNS over TLS:"
        resolvectl status | grep "DNS over TLS"
        echo ""
        echo "DNSSEC:"
        resolvectl status | grep "DNSSEC"
      '')
      
      (writeShellScriptBin "dns-force-adguard" ''
        #!/usr/bin/env bash
        echo "🔒 Forzando DNS AdGuard..."
        
        # Obtener interfaz activa
        INTERFACE=$(nmcli -t -f device,state dev | grep ':connected$' | cut -d: -f1 | head -1)
        
        if [ -z "$INTERFACE" ]; then
          echo "❌ No hay interfaz conectada"
          exit 1
        fi
        
        echo "Interfaz: $INTERFACE"
        
        # Configurar DNS
        resolvectl dns "$INTERFACE" 94.140.14.14 94.140.15.15
        resolvectl domain "$INTERFACE" "~."
        resolvectl dnssec "$INTERFACE" yes
        resolvectl dnsovertls "$INTERFACE" yes
        
        echo "✅ DNS AdGuard activadas"
        dns-status
      '')
      
      (writeShellScriptBin "dns-force-dhcp" ''
        #!/usr/bin/env bash
        echo "🌐 Usando DNS del router (DHCP)..."
        
        # Obtener interfaz activa
        INTERFACE=$(nmcli -t -f device,state dev | grep ':connected$' | cut -d: -f1 | head -1)
        
        if [ -z "$INTERFACE" ]; then
          echo "❌ No hay interfaz conectada"
          exit 1
        fi
        
        echo "Interfaz: $INTERFACE"
        
        # Limpiar configuración DNS
        resolvectl revert "$INTERFACE"
        
        echo "✅ Usando DNS del router"
        dns-status
      '')
    ];

    # ===== PERFIL ALTERNATIVO PARA NETWORKMANAGER =====
    # Crear perfiles específicos para redes universitarias
    environment.etc."NetworkManager/dispatcher.d/pre-up.d/01-university-dns".text = ''
      #!/usr/bin/env bash
      
      # Este script se ejecuta ANTES de conectar
      # Útil para configurar la conexión correctamente desde el inicio
      
      INTERFACE="$1"
      ACTION="$2"
      CONNECTION_ID="$CONNECTION_ID"
      
      if [ "$ACTION" = "pre-up" ]; then
        if [[ "$CONNECTION_ID" == "BAR DIK" ]] || [[ "$CONNECTION_ID" == "UNT" ]]; then
          # Para redes universitarias, asegurar que usen DHCP DNS
          logger "DNS Pre-Config: Red universitaria - DHCP DNS"
        fi
      fi
    '';
  };
}
