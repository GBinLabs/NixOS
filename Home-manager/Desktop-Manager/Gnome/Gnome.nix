{config, lib,pkgs,...}:

{
  dconf.settings = {
    "org/gnome/shell" = {
      favorite-apps = [
        "firefox.desktop"
        "org.gnome.Terminal.desktop"
        "nixos-manual.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      gtk-theme = "Adwaita-dark";
      icon-theme = "Adwaita"; # o Yaru, Papirus, etc.
      cursor-theme = "Adwaita";
    };
    "org/gnome/shell/extensions/user-theme" = {
      name = "Adwaita-dark"; # para el shell si usás User Themes
    };
    "org/gnome/desktop/input-sources" = {
      # Fuentes de entrada (teclado)
      sources = [
        (lib.hm.gvariant.mkTuple [ "xkb" "latam" ])  # Español Latam
        # Añade más layouts si es necesario, ej:
        # (pkgs.lib.hm.gvariant.mkTuple [ "xkb" "us" ])    # Inglés US
      ];
    };
    # Carpeta Utilidades
    "org/gnome/desktop/app-folders/folders/Utilidades" = {
      name = "Utilidades";
      translate = true;
      apps = [
        "org.gnome.baobab.desktop"
        "org.gnome.DiskUtility.desktop"
        "org.gnome.FileRoller.desktop"
        "org.gnome.Evince.desktop"
        "org.gnome.Settings.desktop"
        "org.gnome.Extensions.desktop"
        "org.gnome.TextEditor.desktop"
        "org.freedesktop.Piper.desktop"
      ];
    };

    "org/gnome/desktop/app-folders/folders/LibreOffice" = {
      name = "LibreOffice";
      translate = true;
      apps = [
        "writer.desktop"
        "calc.desktop"
        "impress.desktop"
        "draw.desktop"
        "base.desktop"
        "startcenter.desktop"
        "math.desktop"
      ];
    };

    # Configuración de carpetas de aplicaciones
    "org/gnome/desktop/app-folders" = {
      folder-children = ["Utilidades" "LibreOffice"];
    };
    
    
    
    # 1. Espacios de trabajo estáticos = 1
    "org/gnome/mutter" = {
      dynamic-workspaces = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      num-workspaces = 1;  # Fija a 1 espacio :contentReference[oaicite:0]{index=0}
    };
    
    
    "org/gnome/settings-daemon/plugins/color" = {
      night-light-enabled = true;
      night-light-schedule-automatic = false;
      night-light-schedule-from = 0.0;     # Desde la medianoche
      night-light-schedule-to = 0.0;     # Hasta casi medianoche
      night-light-temperature = 2700;      # Ajusta según tu gusto (1000–6500)
    };
    
     "org/gnome/desktop/peripherals/mouse" = {
      # ¡Clave corregida! (usar "accel-profile" en lugar de "acceleration-profile")
      accel-profile = "flat";
      speed = 0;  # Velocidad neutral (opcional)
    };

    "org/gnome/desktop/peripherals/touchpad" = {
      natural-scroll = true;
      tap-to-click = true;
      click-method = "areas";  # o "fingers"
    };
    
  };
  
  # Si usas otros idiomas, configura la localización global
  home.language = {
    base = "es_AR.UTF-8";  # Configuración regional base
  };
}


