# Home-manager/Aplicaciones/Navegadores/Firefox/Firefox.nix
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

      settings = {
        # === PRIVACIDAD MÁXIMA (CORREGIDA) ===
        "privacy.clearOnShutdown.cache" = true;
        "privacy.clearOnShutdown.cookies" = true;
        "privacy.clearOnShutdown.downloads" = true;
        "privacy.clearOnShutdown.formdata" = true;
        "privacy.clearOnShutdown.history" = true;
        "privacy.clearOnShutdown.sessions" = true;
        "privacy.clearOnShutdown.offlineApps" = true;
        "privacy.sanitize.sanitizeOnShutdown" = true;

        # Resistencia a fingerprinting (SIN letterboxing para Wayland)
        "privacy.resistFingerprinting" = true;
        "privacy.resistFingerprinting.letterboxing" = false; # ← FIX DEL BUG
        "privacy.resistFingerprinting.exemptedDomains" = "*.localhost"; # Excepción para desarrollo local
        "privacy.fingerprintingProtection" = true;
        "privacy.fingerprintingProtection.overrides" = "+AllTargets,-CSSPrefersColorScheme";
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;

        # First Party Isolation
        "privacy.firstparty.isolate" = true;

        # Cookies
        "network.cookie.cookieBehavior" = 5;
        "network.cookie.lifetimePolicy" = 2;
        "privacy.partition.network_state" = true;

        # DNT y GPC
        "privacy.donottrackheader.enabled" = true;
        "privacy.globalprivacycontrol.enabled" = true;

        # WebRTC
        "media.peerconnection.enabled" = false;
        "media.peerconnection.ice.default_address_only" = true;
        "media.peerconnection.ice.no_host" = true;
        "media.peerconnection.ice.proxy_only_if_behind_proxy" = true;

        # Geolocation
        "geo.enabled" = false;
        "geo.provider.network.url" = "";
        "browser.region.network.url" = "";
        "browser.region.update.enabled" = false;

        # Telemetría
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

        # Safebrowsing
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

        # Predicción de red
        "network.predictor.enabled" = false;
        "network.dns.disablePrefetch" = true;
        "network.prefetch-next" = false;
        "network.http.speculative-parallel-limit" = 0;

        # === SEGURIDAD ===
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "dom.security.https_only_mode_send_http_background_request" = false;

        # TLS/SSL
        "security.ssl.require_safe_negotiation" = true;
        "security.tls.enable_0rtt_data" = false;
        "security.ssl.disable_session_identifiers" = true;

        # OCSP
        "security.OCSP.enabled" = 1;
        "security.OCSP.require" = true;

        # Cert
        "security.cert_pinning.enforcement_level" = 2;
        "security.remote_settings.crlite_filters.enabled" = true;
        "security.pki.crlite_mode" = 2;

        # Mixed Content
        "security.mixed_content.block_display_content" = true;
        "security.mixed_content.block_object_subrequest" = true;

        # Permisos
        "permissions.default.geo" = 0;
        "permissions.default.camera" = 0;
        "permissions.default.microphone" = 0;
        "permissions.default.desktop-notification" = 0;
        "permissions.default.xr" = 0;

        # Cross-Origin
        "privacy.partition.serviceWorkers" = true;
        "privacy.partition.always_partition_third_party_non_cookie_storage" = true;
        "privacy.partition.always_partition_third_party_non_cookie_storage.exempt_sessionstorage" = false;

        # === EXTENSIONES EN MODO PRIVADO ===
        "extensions.allowPrivateBrowsingByDefault" = true;

        # === PERFORMANCE (OPTIMIZADO PARA WAYLAND) ===
        # WebRender optimizado para Wayland
        "gfx.webrender.all" = true;
        "gfx.webrender.compositor" = true;
        "gfx.webrender.compositor.force-enabled" = true;
        "gfx.webrender.enabled" = true;
        "gfx.webrender.software" = false;

        # Compositor Wayland
        "widget.wayland.opaque-region.enabled" = true;
        "widget.wayland-dmabuf-vaapi.enabled" = true;
        "widget.wayland-dmabuf-webgl.enabled" = true;

        # Hardware acceleration
        "layers.acceleration.force-enabled" = true;
        "layers.gpu-process.enabled" = true;
        "layers.omtp.enabled" = true; # Off-Main-Thread Painting

        # Hardware video decoding
        "media.hardware-video-decoding.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "media.av1.enabled" = true;
        "media.ffvpx.enabled" = false; # Usar FFmpeg nativo

        # Rendering optimizations
        "gfx.canvas.accelerated" = true;
        "gfx.canvas.accelerated.cache-items" = 4096;
        "gfx.canvas.accelerated.cache-size" = 512;
        "gfx.content.skia-font-cache-size" = 20;

        # Compositor performance
        "layers.omtp.paint-workers" = 4;
        "layers.omtp.release-capture-on-main-thread" = false;

        # Cache
        "browser.cache.disk.enable" = true;
        "browser.cache.memory.enable" = true;
        "browser.cache.memory.capacity" = 524288;
        "browser.cache.disk.capacity" = 1048576;
        "browser.cache.disk.smart_size.enabled" = false;

        # Network
        "network.http.max-connections" = 1800;
        "network.http.max-persistent-connections-per-server" = 10;
        "network.http.http3.enable" = true;
        "network.dns.disableIPv6" = false;

        # JavaScript
        "javascript.options.wasm_caching" = true;
        "javascript.options.parallel_parsing" = true;
        "javascript.options.ion.offthread_compilation" = true;
        "javascript.options.baselinejit" = true;
        "javascript.options.ion" = true;
        "javascript.options.asmjs" = true;
        "javascript.options.wasm" = true;
        "dom.ipc.processCount" = 8;

        # Smooth scrolling optimizado
        "general.smoothScroll" = true;
        "general.smoothScroll.msdPhysics.enabled" = true;
        "general.smoothScroll.msdPhysics.continuousMotionMaxDeltaMS" = 12;
        "general.smoothScroll.msdPhysics.motionBeginSpringConstant" = 200;
        "general.smoothScroll.msdPhysics.slowdownMinDeltaMS" = 10;
        "general.smoothScroll.msdPhysics.slowdownMinDeltaRatio" = 1.0;
        "general.smoothScroll.msdPhysics.slowdownSpringConstant" = 1000;
        "general.smoothScroll.mouseWheel.durationMaxMS" = 200;
        "general.smoothScroll.mouseWheel.durationMinMS" = 100;
        "mousewheel.default.delta_multiplier_y" = 275;

        # Memory
        "browser.sessionstore.interval" = 60000;
        "browser.tabs.unloadOnLowMemory" = true;

        # === WAYLAND ESPECÍFICO ===
        "widget.use-xdg-desktop-portal.file-picker" = 1;
        "widget.use-xdg-desktop-portal.mime-handler" = 1;
        "widget.wayland.use-wl-output-device-model-name" = false;

        # === UX ===
        "browser.download.useDownloadDir" = false;
        "browser.download.always_ask_before_handling_new_types" = true;
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.startup.page" = 1;
        "browser.newtabpage.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
        "browser.newtabpage.activity-stream.default.sites" = "";

        # Autoplay
        "media.autoplay.default" = 5;
        "media.autoplay.blocking_policy" = 2;

        # Popups
        "dom.disable_open_during_load" = true;
        "dom.popup_allowed_events" = "click dblclick mousedown pointerdown";

        # Passwords
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "signon.formlessCapture.enabled" = false;

        # DRM
        "media.eme.enabled" = true;

        # PDF
        "pdfjs.enableScripting" = false;

        # Devtools
        "devtools.debugger.remote-enabled" = false;

        # WebGL
        "webgl.disabled" = false;
        "webgl.enable-debug-renderer-info" = false;
        "webgl.force-enabled" = true;

        # Canvas
        "privacy.resistFingerprinting.randomDataOnCanvasExtract" = true;

        # Extensiones
        "extensions.pocket.enabled" = false;
        "extensions.screenshots.disabled" = true;
        "identity.fxaccounts.enabled" = false;
        "browser.uitour.enabled" = false;

        # Update
        "app.update.auto" = true;
        "extensions.update.enabled" = true;
        # === FIX ESPECÍFICO HYPRLAND ===
        "gfx.webrender.software.opengl" = false;
        "gfx.x11-egl.force-enabled" = false;

        # Deshabilitar compositing problemático
        "layers.offmainthreadcomposition.enabled" = true;
        "layers.offmainthreadcomposition.async-animations" = true;

        # Scrolling más estable
        "apz.allow_zooming" = true;
        "apz.force_disable_desktop_zooming_scrollbars" = false;
        "apz.gtk.kinetic_scroll.enabled" = false; # ← CRÍTICO para Wayland
        "apz.overscroll.enabled" = false;

        # Deshabilitar aceleración de scroll problemática
        "mousewheel.system_scroll_override_on_root_content.enabled" = false;

        # Rendering más conservador
        "gfx.webrender.max-partial-present-rects" = 0;
        "gfx.webrender.batched-upload-threshold" = 512;
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
      DisableFeedbackCommands = true;

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
          "typst.app"
          "www.ar.computrabajo.com"
          "www.linkedin.com"
        ];
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
  };
}
