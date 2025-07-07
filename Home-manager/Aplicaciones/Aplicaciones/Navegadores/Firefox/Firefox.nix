{
  pkgs,
  lib,
  ...
}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    profiles.default = {
      id = 0;
      isDefault = true;

      settings = {
        #################################################
        # SECCIÓN 1: PRIVACIDAD Y PROTECCIÓN CONTRA RASTREO
        #################################################
        # Enhanced Tracking Protection: Modo estricto
        # Estos ajustes bloquean rastreadores de redes sociales, cookies de rastreo,
        # cryptominers y fingerprinters de forma agresiva
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.strictLevel.enabled" = true; # Activa el modo estricto

        # Protección avanzada contra fingerprinting en todas las ventanas
        # (La huella digital del navegador es un método para identificar usuarios basado en características del navegador)
        "privacy.fingerprintingProtection" = true;
        "privacy.fingerprintingProtection.pbmode" = false; # false = protección en todas las ventanas
        "privacy.resistFingerprinting" = false;

        # Global Privacy Control (GPC)
        # Señal automatizada que indica a los sitios web que no vendan ni compartan tus datos
        "privacy.globalprivacycontrol.enabled" = true;

        # Gestión de cookies y datos de sitios
        # Elimina cookies y datos de sitios al cerrar Firefox
        "privacy.sanitize.sanitizeOnShutdown" = true;
        "privacy.clearOnShutdown.cookies" = true;
        "privacy.clearOnShutdown.siteData" = true;
        "privacy.clearOnShutdown.siteSettings" = false; # Mantiene las excepciones

        # Comportamiento de cookies
        # 5 = rechazar cookies de rastreadores y aislar cookies de terceros
        "network.cookie.cookieBehavior" = 5;
        "network.cookie.lifetimePolicy" = 2; # Mantener cookies solo hasta cerrar Firefox

        #################################################
        # SECCIÓN 2: GESTIÓN DE CONTRASEÑAS Y FORMULARIOS
        #################################################
        # Desactivar recordar contraseñas
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "signon.management.page.breach-alerts.enabled" = true; # Mantiene alertas de filtraciones
        "signon.generation.enabled" = false;
        "signon.firefoxRelay.feature" = "disabled";

        # Desactivar autocompletado de formularios
        "browser.formfill.enable" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "browser.formfill.saveHttpsForms" = false;

        #################################################
        # SECCIÓN 3: HISTORIAL Y LIMPIEZA DE DATOS
        #################################################
        # Desactivar almacenamiento de historial
        "places.history.enabled" = false;

        # Limpieza de datos al cerrar Firefox
        "privacy.clearOnShutdown.history" = true;
        "privacy.clearOnShutdown.downloads" = true;
        "privacy.clearOnShutdown.cache" = true;
        "privacy.clearOnShutdown.sessions" = true;
        "privacy.clearOnShutdown.formdata" = true;
        "privacy.clearOnShutdown.offlineApps" = true;

        #################################################
        # SECCIÓN 4: RECOLECCIÓN DE DATOS Y TELEMETRÍA
        #################################################
        # Desactivar toda la telemetría
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;

        # Desactivar estudios de Firefox
        "app.shield.optoutstudies.enabled" = false;

        # Desactivar recomendaciones
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        # Desactivar informes de salud y fallos
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.service.enabled" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        "browser.crashReports.unsubmittedCheck.enabled" = false;
        "browser.ping-centre.telemetry" = false;

        # Desactivar servicio Normandy/Shield (sistema remoto de estudios)
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "identity.fxaccounts.telemetry.clientAssociationPing.enabled" = false;

        #################################################
        # SECCIÓN 5: SEGURIDAD DE RED
        #################################################
        # Activar HTTPS-Only Mode en todas las ventanas
        # Fuerza conexiones HTTPS seguras para todos los sitios
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;

        # DNS sobre HTTPS (DoH) con NextDNS
        # Modo 3 = Solo DoH, sin fallback a DNS tradicional
        "network.trr.mode" = 3;
        "network.trr.custom_uri" = "https://dns0.eu"; # Reemplazar 'asd' con tu ID
        "network.trr.uri" = "https://dns0.eu"; # Reemplazar 'asd' con tu ID
        "network.trr.confirmationNS" = "skip";
        "network.dns.skipTRR-when-parental-control-enabled" = false;

        # Habilitar HTTP/3 (QUIC) para mejor rendimiento y seguridad (nueva adición)
        "network.http.http3.enabled" = true;

        #################################################
        # SECCIÓN 6: MOTOR DE BÚSQUEDA Y BARRA DE DIRECCIONES
        #################################################
        # Configuración de DuckDuckGo como motor predeterminado
        "browser.urlbar.placeholderName" = "DuckDuckGo";
        "browser.urlbar.placeholderName.private" = "DuckDuckGo";
        "browser.search.defaultenginename" = "DuckDuckGo";
        "browser.search.selectedEngine" = "DuckDuckGo";
        "browser.search.order.1" = "DuckDuckGo";

        # Desactivar términos de búsqueda en la barra de direcciones
        "browser.urlbar.showSearchTerms.enabled" = false;

        # Desactivar sugerencias de búsqueda
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.search.suggest.enabled.private" = false;
        "browser.urlbar.trending.featureGate" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.suggest.topsites" = false;

        # Desactivar sugerencias en la barra de direcciones
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.quickactions" = false;
        "browser.urlbar.shortcuts.enabled" = false;

        # Configuraciones adicionales de barra de direcciones
        "browser.urlbar.matchBuckets.bookmarks" = "UNIFIEDCOMPLETE_FLAT";
        "browser.urlbar.matchBuckets.history" = "UNIFIEDCOMPLETE_FLAT";
        "browser.urlbar.matchBuckets.searches" = "";
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.urlbar.suggest.searches.recent" = false;
        "browser.urlbar.maxHistoricalSearchSuggestions" = 0;

        # Desactivar atajos de búsqueda
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.actions" = false;
        "browser.urlbar.restrict.searches" = "*";
        "browser.search.history.showSearchTerms" = false;
        "browser.urlbar.autoFill.searchEngines" = false;

        #################################################
        # SECCIÓN 7: PÁGINA DE INICIO Y NUEVA PESTAÑA
        #################################################
        # Desactivar elementos de la página de inicio
        "browser.newtabpage.activity-stream.showSearch" = false;
        "browser.newtabpage.activity-stream.showShortcuts" = false;
        "browser.newtabpage.activity-stream.shortcuts.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.system.topstories" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeVisited" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeBookmarks" = false;
        "browser.newtabpage.activity-stream.section.highlights.includeDownloads" = false;
        "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
        "browser.newtabpage.activity-stream.feeds.recommendationprovider" = false;

        # Desactivar secciones completas
        "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
        "browser.newtabpage.activity-stream.feeds.sections" = false;
        "browser.newtabpage.activity-stream.topSitesRows" = 0;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;

        # Página de nueva pestaña limpia
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.newtabpage.activity-stream.default.sites" = "";
        "browser.newtabpage.activity-stream.discoverystream.config" = "{}";
        "browser.newtabpage.activity-stream.discoverystream.enabled" = false;
        "browser.newtabpage.activity-stream.enabled" = false;

        #################################################
        # SECCIÓN 8: INTEGRACIONES Y SERVICIOS
        #################################################
        # Configuración de descargas
        "browser.download.useDownloadDir" = false; # Preguntar siempre dónde guardar
        "browser.download.always_ask_before_handling_new_types" = true;

        # Configuración de DRM
        "media.eme.enabled" = true; # Permitir contenido con DRM

        # Desactivar Pocket completamente
        "extensions.pocket.enabled" = false;
        "extensions.pocket.api" = "";
        "extensions.pocket.oAuthConsumerKey" = "";
        "extensions.pocket.site" = "";

        # Desactivar la integración de cuentas Firefox
        "identity.fxaccounts.enabled" = false;
        "browser.newtabpage.activity-stream.fxaccounts.endpoint" = "";

        #################################################
        # SECCIÓN 9: APARIENCIA Y TEMA
        #################################################
        # Habilitar modo oscuro
        "browser.in-content.dark-mode" = true;
        "ui.systemUsesDarkTheme" = 1;

        # Configuraciones para transparencia
        "browser.theme.toolbar-theme" = 0;
        "browser.theme.content-theme" = 0;

        # Configuración para elementos visuales
        "browser.tabs.tabClipWidth" = 0;
        "browser.tabs.tabMinWidth" = 76;

        # Color de fondo oscuro-azulado
        "browser.display.background_color" = "#0A1019";

        # Activar CSS personalizado
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        # Mostrar la barra de marcadores siempre
        "browser.toolbars.bookmarks.visibility" = "always";

        #################################################
        # SECCIÓN 10: RENDIMIENTO (Nuevas adiciones)
        #################################################
        # Habilitar aceleración por hardware cuando esté disponible
        "layers.acceleration.force-enabled" = true;

        # Procesamiento en segundo plano para mejor desempeño
        "dom.ipc.processCount" = 8; # Aumentar el número de procesos

        # WebRender para renderización GPU (mejor rendimiento)
        "gfx.webrender.all" = true;

        # Descargas paralelas para mayor velocidad
        "browser.download.improvements_to_download_panel" = true;

        #################################################
        # SECCIÓN 11: CONTENEDORES (Nueva funcionalidad)
        #################################################
        # Habilitar contenedores (aislamiento de cookies/sesiones)
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;
        "privacy.userContext.extension.enabled" = true;
      };

      # Configuración de motores de búsqueda
      search = {
        force = true;
        engines = {
          "google".metaData.hidden = true;
          "bing".metaData.hidden = true;
          "amazondotcom-us".metaData.hidden = true;
          "ebay".metaData.hidden = true;
          "wikipedia".metaData.hidden = true;
        };
      };

      bookmarks = {
        force = true;
        settings = lib.importJSON ./Bookmarks.json;
      };
    };

    # Políticas y extensiones
    policies = {
      # Configuración de extensiones
      ExtensionSettings = {
        "*".installation_mode = "blocked";

        # Bloqueador de publicidad y rastreadores
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };

        # Privacy Badger
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };

        # DuckDuckGo Privacy Essentials
        "jid1-ZAdIEUB7XOzOJw@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-for-firefox/latest.xpi";
          installation_mode = "force_installed";
        };

        # LanguageTool
        "languagetool-webextension@languagetool.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/languagetool/latest.xpi";
          installation_mode = "force_installed";
        };
      };

      # Políticas adicionales
      DisableTelemetry = true;
      DisablePocket = true;
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DisableFirefoxScreenshots = true;
      DisableFormHistory = true;
      PasswordManagerEnabled = false;

      # Configuraciones de búsqueda y sugerencias
      SearchSuggestEnabled = false;

      # Actualizaciones de extensiones
      ExtensionUpdate = true;

      Cookies = {
        Allow = map (d: "https://${d}") [
          "accounts.google.com"
          "account.proton.me"
          "chat.deepseek.com"
          "chatgpt.com"
          "claude.ai"
          "github.com"
        ];
      };
    };
  };
}
