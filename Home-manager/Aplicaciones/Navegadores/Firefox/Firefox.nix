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
        # ===== TRACKING PROTECTION =====
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.strictLevel.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.fingerprintingProtection.pbmode" = true; # Cambié a true
        "privacy.resistFingerprinting" = false; # IMPORTANTE: Cambié a true para máxima privacidad
        "privacy.resistFingerprinting.letterboxing" = false; # Nueva: Dificulta fingerprinting por tamaño de ventana
        "privacy.globalprivacycontrol.enabled" = true;

        # ===== SANITIZACIÓN Y COOKIES =====
        "privacy.sanitize.sanitizeOnShutdown" = true;
        "privacy.clearOnShutdown.cookies" = true;
        "privacy.clearOnShutdown.siteData" = true;
        "privacy.clearOnShutdown.siteSettings" = false;
        "privacy.clearOnShutdown.history" = true;
        "privacy.clearOnShutdown.downloads" = true;
        "privacy.clearOnShutdown.cache" = true;
        "privacy.clearOnShutdown.sessions" = true;
        "privacy.clearOnShutdown.formdata" = true;
        "privacy.clearOnShutdown.offlineapps" = true;
        "network.cookie.cookieBehavior" = 5; # Total Cookie Protection
        "network.cookie.lifetimePolicy" = 2;
        "network.cookie.thirdparty.sessionOnly" = true; # Nueva
        "network.cookie.thirdparty.nonsecureSessionOnly" = true; # Nueva

        # ===== FORMULARIOS Y CONTRASEÑAS =====
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "signon.management.page.breach-alerts.enabled" = true;
        "signon.generation.enabled" = false;
        "signon.firefoxRelay.feature" = "disabled";
        "browser.formfill.enable" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "browser.formfill.saveHttpsForms" = false;

        # ===== HISTORIAL =====
        "places.history.enabled" = false;

        # ===== TELEMETRÍA =====
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false; # Nueva
        "toolkit.telemetry.coverage.opt-out" = true; # Nueva
        "toolkit.coverage.opt-out" = true; # Nueva
        "toolkit.coverage.endpoint.base" = ""; # Nueva
        "app.shield.optoutstudies.enabled" = false;
        "browser.discovery.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "datareporting.healthreport.service.enabled" = false;
        "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
        "browser.crashReports.unsubmittedCheck.enabled" = false;
        "browser.ping-centre.telemetry" = false;
        "app.normandy.enabled" = false;
        "app.normandy.api_url" = "";
        "identity.fxaccounts.telemetry.clientAssociationPing.enabled" = false;

        # ===== HTTPS Y SEGURIDAD =====
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "dom.security.https_only_mode_send_http_background_request" = false; # Nueva
        "security.ssl.require_safe_negotiation" = true; # Nueva
        "security.tls.enable_0rtt_data" = false; # Nueva: Previene replay attacks

        # ===== DNS OVER HTTPS =====
        "network.trr.mode" = 3;
        "network.trr.custom_uri" = "https://dns.adguard-dns.com/dns-query";
        "network.trr.uri" = "https://dns.adguard-dns.com/dns-query";
        "network.trr.confirmationNS" = "skip";
        "network.dns.skipTRR-when-parental-control-enabled" = false;
        "network.dns.disablePrefetch" = true; # Nueva
        "network.dns.disablePrefetchFromHTTPS" = true; # Nueva
        "network.predictor.enabled" = false; # Nueva
        "network.prefetch-next" = false; # Nueva
        "network.http.speculative-parallel-limit" = 0; # Nueva

        # ===== HTTP/3 =====
        "network.http.http3.enabled" = true;

        # ===== WEBRTC - IMPORTANTE PARA PRIVACIDAD =====
        "media.peerconnection.enabled" = true; # Mantén esto si usas videollamadas
        "media.peerconnection.ice.default_address_only" = true; # Nueva: No expone IPs locales
        "media.peerconnection.ice.no_host" = true; # Nueva: Oculta IP local
        "media.peerconnection.ice.proxy_only_if_behind_proxy" = true; # Nueva
        "media.navigator.enabled" = true; # Mantén si usas cámara/micrófono

        # ===== REFERERS - MUY IMPORTANTE PARA PRIVACIDAD =====
        "network.http.referer.XOriginPolicy" = 2; # Nueva: Solo envía referer al mismo sitio
        "network.http.referer.XOriginTrimmingPolicy" = 2; # Nueva: Solo envía origen en cross-origin
        "network.http.referer.trimmingPolicy" = 2; # Nueva

        # ===== GEO-LOCALIZACIÓN =====
        "geo.enabled" = false; # Nueva: Deshabilita geolocalización
        "geo.provider.network.url" = ""; # Nueva
        "geo.provider.ms-windows-location" = false; # Nueva
        "geo.provider.use_corelocation" = false; # Nueva
        "geo.provider.use_gpsd" = false; # Nueva
        "geo.provider.use_geoclue" = false; # Nueva

        # ===== SENSOR Y HARDWARE APIs =====
        "device.sensors.enabled" = false; # Nueva: Deshabilita acelerómetro, giroscopio, etc.
        "dom.battery.enabled" = false; # Nueva: Oculta nivel de batería
        "dom.event.clipboardevents.enabled" = false; # Nueva: Previene detección de copiar/pegar

        # ===== NOTIFICACIONES =====
        "dom.webnotifications.enabled" = false; # Nueva: Deshabilita notificaciones web
        "dom.push.enabled" = false; # Nueva
        "dom.push.connection.enabled" = false; # Nueva

        # ===== BEACON API =====
        "beacon.enabled" = false; # Nueva: Previene tracking al salir de páginas

        # ===== BÚSQUEDA =====
        "browser.urlbar.placeholderName" = "DuckDuckGo";
        "browser.urlbar.placeholderName.private" = "DuckDuckGo";
        "browser.search.defaultenginename" = "DuckDuckGo";
        "browser.search.selectedEngine" = "DuckDuckGo";
        "browser.search.order.1" = "DuckDuckGo";
        "browser.urlbar.showSearchTerms.enabled" = false;
        "browser.search.suggest.enabled" = false;
        "browser.urlbar.suggest.searches" = false;
        "browser.search.suggest.enabled.private" = false;
        "browser.urlbar.trending.featureGate" = false;
        "browser.urlbar.suggest.quicksuggest.sponsored" = false;
        "browser.urlbar.suggest.quicksuggest.nonsponsored" = false;
        "browser.urlbar.suggest.topsites" = false;
        "browser.urlbar.suggest.history" = false;
        "browser.urlbar.suggest.bookmark" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.quickactions" = false;
        "browser.urlbar.shortcuts.enabled" = false;
        "browser.urlbar.matchBuckets.bookmarks" = "UNIFIEDCOMPLETE_FLAT";
        "browser.urlbar.matchBuckets.history" = "UNIFIEDCOMPLETE_FLAT";
        "browser.urlbar.matchBuckets.searches" = "";
        "browser.urlbar.showSearchSuggestionsFirst" = false;
        "browser.urlbar.suggest.searches.recent" = false;
        "browser.urlbar.maxHistoricalSearchSuggestions" = 0;
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.actions" = false;
        "browser.urlbar.restrict.searches" = "*";
        "browser.search.history.showSearchTerms" = false;
        "browser.urlbar.autoFill.searchEngines" = false;

        # ===== NUEVA PESTAÑA =====
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
        "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
        "browser.newtabpage.activity-stream.feeds.sections" = false;
        "browser.newtabpage.activity-stream.topSitesRows" = 0;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.startup.homepage_override.mstone" = "ignore";
        "browser.newtabpage.activity-stream.default.sites" = "";
        "browser.newtabpage.activity-stream.discoverystream.config" = "{}";
        "browser.newtabpage.activity-stream.discoverystream.enabled" = false;
        "browser.newtabpage.activity-stream.enabled" = false;

        # ===== DESCARGAS =====
        "browser.download.useDownloadDir" = false;
        "browser.download.always_ask_before_handling_new_types" = true;

        # ===== DRM =====
        "media.eme.enabled" = true;

        # ===== POCKET =====
        "extensions.pocket.enabled" = false;
        "extensions.pocket.api" = "";
        "extensions.pocket.oAuthConsumerKey" = "";
        "extensions.pocket.site" = "";

        # ===== FIREFOX ACCOUNTS =====
        "identity.fxaccounts.enabled" = false;
        "browser.newtabpage.activity-stream.fxaccounts.endpoint" = "";

        # ===== TEMA =====
        "browser.in-content.dark-mode" = true;
        "ui.systemUsesDarkTheme" = 1;
        "browser.theme.toolbar-theme" = 0;
        "browser.theme.content-theme" = 0;
        "browser.tabs.tabClipWidth" = 0;
        "browser.tabs.tabMinWidth" = 76;
        "browser.display.background_color" = "#0A1019";
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.toolbars.bookmarks.visibility" = "always";

        # ===== RENDIMIENTO =====
        "layers.acceleration.force-enabled" = true;
        "dom.ipc.processCount" = 8;
        "gfx.webrender.all" = true;
        "browser.download.improvements_to_download_panel" = true;

        # ===== CONTAINERS =====
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;
        "privacy.userContext.extension.enabled" = true;

        # ===== CONFIGURACIONES ADICIONALES DE PRIVACIDAD =====
        "browser.safebrowsing.malware.enabled" = true; # Nueva: Deshabilita conexión a Google
        "browser.safebrowsing.phishing.enabled" = true; # Nueva
        "browser.safebrowsing.downloads.enabled" = true; # Nueva
        "browser.safebrowsing.downloads.remote.enabled" = true; # Nueva
        "browser.selfsupport.url" = ""; # Nueva
        "browser.send_pings" = false; # Nueva: Previene tracking pings
        "browser.send_pings.require_same_host" = true; # Nueva

        # ===== AUTOPLAY =====
        "media.autoplay.default" = 0; # Nueva: Bloquea autoplay de audio y video
        "media.autoplay.blocking_policy" = 0; # Nueva

        # ===== PERMISOS =====
        "permissions.default.camera" = 2; # Nueva: Bloquea cámara por defecto
        "permissions.default.microphone" = 2; # Nueva: Bloquea micrófono por defecto
        "permissions.default.desktop-notification" = 2; # Nueva
        "permissions.default.geo" = 2; # Nueva

        # ===== CACHE =====
        "browser.cache.disk.enable" = false; # Nueva: Deshabilita cache en disco
        "browser.cache.memory.enable" = true; # Nueva: Solo cache en RAM
        "browser.privatebrowsing.forceMediaMemoryCache" = true; # Nueva
        "browser.sessionstore.privacy_level" = 2; # Nueva: No guarda datos de sesión

        # ===== PRELOAD/PREFETCH =====
        "network.http.referer.disallowCrossSiteRelaxingDefault.top_navigation" = true; # Nueva
        "network.http.referer.disallowCrossSiteRelaxingDefault" = true; # Nueva

        "browser.preferences.moreFromMozilla" = false;
        "browser.urlbar.recentsearches.featureGate" = false;
      };

      search = {
        force = true;
        engines = {
          "google".metaData.hidden = true;
          "bing".metaData.hidden = true;
          "amazondotcom-us".metaData.hidden = true;
          "ebay".metaData.hidden = true;
          "perplexity".metaData.hidden = true;
          "wikipedia".metaData.hidden = true;
        };
      };

      bookmarks = {
        force = true;
        settings = lib.importJSON ./Bookmarks.json;
      };
    };

    policies = {
      ExtensionSettings = {
        "*".installation_mode = "blocked";

        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
        };

        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
        };

        "jid1-ZAdIEUB7XOzOJw@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-for-firefox/latest.xpi";
          installation_mode = "force_installed";
        };

        "languagetool-webextension@languagetool.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/file/4470413/languagetool-8.19.4.xpi";
          installation_mode = "force_installed";
        };
      };

      DisableTelemetry = true;
      DisablePocket = true;
      DisableFirefoxStudies = true;
      DisableFirefoxAccounts = true;
      OverrideFirstRunPage = "";
      OverridePostUpdatePage = "";
      DisableFirefoxScreenshots = true;
      DisableFormHistory = true;
      PasswordManagerEnabled = false;
      SearchSuggestEnabled = false;
      ExtensionUpdate = true;

      # Nueva: Deshabilita más telemetría a nivel de política
      DisableAppUpdate = false; # Mantén actualizaciones de seguridad
      DisableSystemAddonUpdate = false;
      DisableFeedbackCommands = true;

      # Nueva: Bloquea más características de rastreo
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };

      Cookies = {
        Allow = map (d: "https://${d}") [
          "accounts.google.com"
          "account.proton.me"
          "chat.deepseek.com"
          "chatgpt.com"
          "claude.ai"
          "github.com"
          "gitlab.com"
          "www.ar.computrabajo.com"
          "www.linkedin.com"
        ];
        # Bloquea third-party cookies excepto para sitios permitidos
        Behavior = "reject-tracker-and-partition-foreign";
      };
    };
  };
}
