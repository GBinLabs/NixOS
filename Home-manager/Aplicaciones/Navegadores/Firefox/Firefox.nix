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

      # Home-manager/Aplicaciones/Navegadores/Firefox/Firefox.nix (settings optimizados)
      settings = {
        # === PRIVACIDAD ESENCIAL ===
        "privacy.trackingprotection.enabled" = true;
        "privacy.resistFingerprinting" = false; # Causa problemas con Wayland
        "privacy.clearOnShutdown.cookies" = true;
        "network.cookie.cookieBehavior" = 5;

        # === RENDIMIENTO ===
        "layers.acceleration.force-enabled" = true;
        "gfx.webrender.all" = true;
        "dom.ipc.processCount" = 8;

        # === WAYLAND ===
        "widget.use-xdg-desktop-portal" = true;
        "media.ffmpeg.vaapi.enabled" = true;

        # === ELIMINAR TELEMETRÍA ===
        "toolkit.telemetry.enabled" = false;
        "datareporting.healthreport.uploadEnabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;

        # === UX ===
        "browser.toolbars.bookmarks.visibility" = "always";
        "browser.download.useDownloadDir" = false;
        "media.eme.enabled" = true; # DRM para streaming
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
