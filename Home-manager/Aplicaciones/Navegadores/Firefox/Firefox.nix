# Home-manager/Aplicaciones/Navegadores/Firefox/Firefox.nix
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
        # === PRIVACIDAD ===
        "privacy.trackingprotection.enabled" = true;
        "privacy.clearOnShutdown.cookies" = true;
        "network.cookie.cookieBehavior" = 5;
        
        # === PERFORMANCE MÁXIMO ===
        "layers.acceleration.force-enabled" = true;
        "gfx.webrender.all" = true;
        "gfx.webrender.compositor.force-enabled" = true;
        "dom.ipc.processCount" = 8;
        
        # GPU
        "layers.gpu-process.enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
        "media.hardware-video-decoding.force-enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;
        "media.rdd-ffmpeg.enabled" = true;
        "media.av1.enabled" = true;
        
        # Multithreading
        "dom.ipc.processCount.webIsolated" = 4;
        "javascript.options.wasm_caching" = true;
        "javascript.options.parallel_parsing" = true;
        
        # Cache agresivo
        "browser.cache.disk.enable" = true;
        "browser.cache.memory.enable" = true;
        "browser.cache.memory.capacity" = 524288;  # 512MB
        
        # === WAYLAND ===
        "widget.use-xdg-desktop-portal" = true;
        #"media.ffmpeg.vaapi.enabled" = true;
        
        # === TELEMETRÍA OFF ===
        "toolkit.telemetry.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        
        # === UX ===
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.download.useDownloadDir" = false;
        "media.eme.enabled" = true;
        
        # Smooth scroll
        "general.smoothScroll" = true;
        "general.smoothScroll.msdPhysics.enabled" = true;
        
        # Reducir consumo RAM
        "browser.sessionstore.interval" = 60000;  # 1min
        "browser.tabs.unloadOnLowMemory" = true;
        
        # HTTP/3
        "network.http.http3.enable" = true;
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
          "www.ar.computrabajo.com"
          "www.linkedin.com"
        ];
        Behavior = "reject-tracker-and-partition-foreign";
      };
      
      # Performance extras
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
