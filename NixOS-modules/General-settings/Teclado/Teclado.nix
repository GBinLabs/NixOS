_: {

  # Configuración de teclado español latinoamericano
  services.xserver = {
    xkb = {
      layout = "latam";
      variant = "";
      options = "grp:alt_shift_toggle"; # Opcional: para alternar layouts si usa múltiples
    };
  };

  # Configuración de consola para mantener consistencia
  console = {
    useXkbConfig = true; # Usa la misma configuración de teclado para la consola
  };

  i18n = {
    defaultLocale = "es_AR.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "es_AR.UTF-8";
      LC_IDENTIFICATION = "es_AR.UTF-8";
      LC_MEASUREMENT = "es_AR.UTF-8";
      LC_MONETARY = "es_AR.UTF-8";
      LC_NAME = "es_AR.UTF-8";
      LC_NUMERIC = "es_AR.UTF-8";
      LC_PAPER = "es_AR.UTF-8";
      LC_TELEPHONE = "es_AR.UTF-8";
      LC_TIME = "es_AR.UTF-8";
    };
  };

  #console.keyMap = "la-latin1";
}
