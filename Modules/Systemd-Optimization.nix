# Modules/Systemd-Optimization.nix
{ ... }: {
  systemd = {
    services = {
      NetworkManager-wait-online.enable = false;
      systemd-udev-settle.enable = false;
      
      systemd-resolved.serviceConfig = {
        Restart = "on-failure";
        RestartSec = 1;
      };
    };
    
    sleep.extraConfig = ''
      AllowSuspend=yes
      AllowHibernation=no
      AllowSuspendThenHibernate=no
      AllowHybridSleep=no
    '';
    
    tmpfiles.rules = [
      "d /tmp 1777 root root 1d"
      "d /var/log/journal 0755 root systemd-journal - -"
    ];
    
    # Optimizar timers
    timers = {
      # GC más frecuente pero menos agresivo
      nix-gc = {
        timerConfig = {
          OnCalendar = "weekly";
          Persistent = true;
        };
      };
    };
  };
  
  services.journald.extraConfig = ''
    SystemMaxUse=100M
    MaxFileSec=7day
    MaxRetentionSec=1week
    ForwardToSyslog=no
    ForwardToKMsg=no
    ForwardToConsole=no
    ForwardToWall=no
  '';
  
  boot.loader.timeout = 0;
}
