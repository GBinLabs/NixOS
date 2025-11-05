{
  pkgs,
  lib,
  ...
}: {
  programs.librewolf = {
    enable = true;
    package = pkgs.librewolf;

    profiles.default = {
      id = 0;
      isDefault = true;

      settings = lib.mkForce {
        # === PRIVACIDAD y FINGERPRINTING (conservadas) ===
        "privacy.clearOnShutdown.cache" = true;
        "privacy.clearOnShutdown.cookies" = true;
        "privacy.clearOnShutdown.downloads" = true;
        "privacy.clearOnShutdown.formdata" = true;
        "privacy.clearOnShutdown.history" = true;
        "privacy.clearOnShutdown.sessions" = true;
        "privacy.clearOnShutdown.offlineApps" = true;
        "privacy.sanitize.sanitizeOnShutdown" = true;

        "privacy.resistFingerprinting" = true;
        "privacy.resistFingerprinting.letterboxing" = false;
        "privacy.resistFingerprinting.exemptedDomains" = "*.localhost";
        "privacy.fingerprintingProtection" = true;
        "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";

        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.firstparty.isolate" = true;

        "network.cookie.cookieBehavior" = 5;
        "network.cookie.lifetimePolicy" = 2;
        "privacy.partition.network_state" = true;

        "privacy.donottrackheader.enabled" = true;
        "privacy.globalprivacycontrol.enabled" = true;

        "media.peerconnection.enabled" = false;
        "media.peerconnection.ice.default_address_only" = true;
        "media.peerconnection.ice.no_host" = true;
        "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;

        "geo.enabled" = false;
        "geo.provider.network.url" = "";
        "browser.region.network.url" = "";
        "browser.region.update.enabled" = false;

        # Telemetría (conservadas)
        "datareporting.healthreport.uploadEnabled" = false;
        "datareporting.policy.dataSubmissionEnabled" = false;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.coverage.opt-out" = true;
        "toolkit.coverage.opt-out" = true;
        "browser.ping-centre.telemetry" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;

        # Safebrowsing desactivado (conservado)
        "browser.safebrowsing.malware.enabled" = false;
        "browser.safebrowsing.phishing.enabled" = false;
        "browser.safebrowsing.downloads.enabled" = false;
        "browser.safebrowsing.downloads.remote.enabled" = false;
        "browser.safebrowsing.downloads.remote.block_potentially_unwanted" = false;
        "browser.safebrowsing.downloads.remote.block_uncommon" = false;
        "browser.safebrowsing.provider.google.updateURL" = "";
        "browser.safebrowsing.provider.google.gethashURL" = "";
        "browser.safebrowsing.provider.google4.updateURL" = "";
        "browser.safebrowsing.provider.google4.gethashURL" = "";

        # Seguridad TLS/OCSP/Cert
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "dom.security.https_only_mode_send_http_background_request" = false;

        "security.ssl.require_safe_negotiation" = true;
        "security.tls.enable_0rtt_data" = false;
        "security.ssl.disable_session_identifiers" = true;

        "security.OCSP.enabled" = 1;
        "security.OCSP.require" = true;

        "security.cert_pinning.enforcement_level" = 2;
        "security.remote_settings.crlite_filters.enabled" = true;
        "security.pki.crlite_mode" = 2;

        "security.mixed_content.block_display_content" = true;
        "security.mixed_content.block_object_subrequest" = true;

        # Permisos (conservados)
        "permissions.default.geo" = 0;
        "permissions.default.camera" = 0;
        "permissions.default.microphone" = 0;
        "permissions.default.desktop-notification" = 0;
        "permissions.default.xr" = 0;

        # PERFORMANCE wayland (conservado)
        "gfx.webrender.all" = true;
        "gfx.webrender.compositor" = true;
        "gfx.webrender.compositor.force-enabled" = true;
        "gfx.webrender.enabled" = true;
        "gfx.webrender.software" = false;
        "widget.wayland.opaque-region.enabled" = true;
        "widget.wayland-dmabuf-vaapi.enabled" = true;
        "widget.wayland-dmabuf-webgl.enabled" = true;

        "layers.acceleration.force-enabled" = true;
        "layers.gpu-process.enabled" = true;
        "layers.omtp.enabled" = true;

        "media.hardware-video-decoding.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "media.av1.enabled" = true;
        "media.ffvpx.enabled" = false;

        "gfx.canvas.accelerated" = true;
        "gfx.canvas.accelerated.cache-items" = 4096;
        "gfx.canvas.accelerated.cache-size" = 512;
        "gfx.content.skia-font-cache-size" = 20;

        "layers.omtp.paint-workers" = 4;
        "layers.omtp.release-capture-on-main-thread" = false;

        "browser.cache.disk.enable" = true;
        "browser.cache.memory.enable" = true;
        "browser.cache.memory.capacity" = 524288;
        "browser.cache.disk.capacity" = 1048576;
        "browser.cache.disk.smart_size.enabled" = false;

        "network.http.max-connections" = 1800;
        "network.http.max-persistent-connections-per-server" = 10;
        "network.http.http3.enable" = true;
        "network.dns.disableIPv6" = false;

        "javascript.options.wasm_caching" = true;
        "javascript.options.parallel_parsing" = true;
        "javascript.options.ion.offthread_compilation" = true;
        "javascript.options.baselinejit" = true;
        "javascript.options.ion" = true;
        "javascript.options.asmjs" = true;
        "javascript.options.wasm" = true;
        "dom.ipc.processCount" = 8;

        "general.smoothScroll" = true;
        "general.smoothScroll.msdPhysics.enabled" = true;

        "browser.sessionstore.interval" = 60000;
        "browser.tabs.unloadOnLowMemory" = true;

        # WAYLAND specifics
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;
        "widget.wayland.use-wl-output-device-model-name" = false;

        # UX
        "browser.download.useDownloadDir" = false;
        "browser.download.always_ask_before_handling_new_types" = true;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.startup.page" = 1;
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.default.sites" = "";

        "media.autoplay.default" = 5;
        "media.autoplay.blocking_policy" = 2;

        "dom.disable_open_during_load" = true;
        "dom.popup_allowed_events" = "click dblclick mousedown pointerdown";

        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "signon.formlessCapture.enabled" = false;

        "media.eme.enabled" = true;
        "pdfjs.enableScripting" = false;
        "devtools.debugger.remote-enabled" = false;

        "webgl.disabled" = false;
        "webgl.enable-debug-renderer-info" = false;
        "webgl.force-enabled" = true;

        "privacy.resistFingerprinting.randomDataOnCanvasExtract" = true;

        "extensions.pocket.enabled" = false;
        "extensions.screenshots.disabled" = true;
        "identity.fxaccounts.enabled" = false;
        "browser.uitour.enabled" = false;

        # === ACTUALIZACIONES / LOCKS (coherentes para pinear LT) ===
        # Desactivar updates de extensiones en runtime
        "extensions.update.enabled" = false; # no comprobar actualizaciones de add-ons
        "extensions.update.autoUpdateDefault" = false; # no auto-actualizar si posible
        "extensions.update.background.enabled" = false; # no comprobación en background

        # Desactivar auto-instalación automática del navegador
        "app.update.auto" = false;

        # Fix Hyprland / compositing
        "gfx.webrender.software.opengl" = false;
        "gfx.x11-egl.force-enabled" = false;

        "layers.offmainthreadcomposition.enabled" = true;
        "layers.offmainthreadcomposition.async-animations" = true;

        "apz.allow_zooming" = true;
        "apz.overscroll.enabled" = false;
        "apz.gtk.kinetic_scroll.enabled" = false;

        "mousewheel.system_scroll_override_on_root_content.enabled" = false;

        "gfx.webrender.max-partial-present-rects" = 0;
        "gfx.webrender.batched-upload-threshold" = 512;
      };

      # Buscador y bookmarks sin cambios funcionales
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
  };

  # POLICIES: control centralizado (policies.json emulado)
  # - ExtensionSettings: bloquea todo salvo los forzados.
  # - ExtensionUpdate: false -> evita que la política permita actualizaciones forzadas.
  # - DisableFirefoxStudies / telemetry / etc. consolidadas.
  programs.librewolf.policies = {
    ExtensionSettings = {
      "*".installation_mode = "blocked";

      # uBlock, Privacy Badger, DuckDuckGo: forzar instalación desde AMO usual.
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

    # IMPORTANTE: desactivar que la política permita actualizaciones de extensiones
    ExtensionUpdate = false;

    DisableTelemetry = true;
    DisablePocket = true;
    DisableFirefoxStudies = true;
    DisableFirefoxAccounts = true;
    DisableFirefoxScreenshots = true;
    DisableFormHistory = true;
    PasswordManagerEnabled = false;
    SearchSuggestEnabled = false;
    DisableFeedbackCommands = true;

    EnableTrackingProtection = {
      Value = true;
      Locked = true;
      Cryptomining = true;
      Fingerprinting = true;
    };

    Cookies = {
      Allow = lib.listToAttrs (map (d: {
          name = d;
          value = "https://${d}";
        }) [
          "accounts.google.com"
          "account.proton.me"
          "chat.deepseek.com"
          "chatgpt.com"
          "claude.ai"
          "github.com"
          "gitlab.com"
          "typst.app"
          "www.ar.computrabajo.com"
          "www.linkedin.com"
        ]);
      Behavior = "reject-tracker-and-partition-foreign";
    };

    HardwareAcceleration = true;

    Handlers = {
      mimeTypes = {
        "application/pdf" = {
          action = "useSystemDefault";
        };
      };
    };
  };
}
