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
        # Privacidad esencial
        "privacy.resistFingerprinting" = true;
        "privacy.clearOnShutdown.history" = true;
        "privacy.trackingprotection.enabled" = true;
        "privacy.firstparty.isolate" = true;

        # Seguridad
        "dom.security.https_only_mode" = true;
        "security.ssl.require_safe_negotiation" = true;

        # Performance Wayland
        "gfx.webrender.all" = true;
        "widget.wayland-dmabuf-vaapi.enabled" = true;
        "media.hardware-video-decoding.enabled" = true;
        "media.ffmpeg.vaapi.enabled" = true;

        # Cache y memoria
        "browser.cache.memory.capacity" = 524288;
        "javascript.options.wasm_caching" = true;

        # UX
        "browser.download.useDownloadDir" = false;
        "media.autoplay.default" = 5;
        "media.eme.enabled" = true;
      };

      search.force = true;
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
      	install_url = "https://addons.mozilla.org/firefox/downloads/latest/languagetool-webextension/latest.xpi";
      installation_mode = "force_installed";
    };
    
    
      };

      ExtensionUpdate = true;
      DisableTelemetry = true;
      DisablePocket = true;
      PasswordManagerEnabled = false;

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
  };
}
