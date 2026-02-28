{
  pkgs,
  lib,
  ...
}:
{
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    profiles.default = {
      id = 0;
      isDefault = true;
      search.force = true;
      settings = {
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
          private_browsing = true;
        };
        "jid1-MnnxcxisBPnSXQ@jetpack" = {
          install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/privacy-badger17/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        "jid1-ZAdIEUB7XOzOJw@jetpack" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/duckduckgo-for-firefox/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
        };
        "pywalfox@frewacom.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/pywalfox/latest.xpi";
          installation_mode = "force_installed";
          private_browsing = true;
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

      Cookies = {
        Allow = map (d: "https://${d}") [
          "accounts.google.com"
          "account.proton.me"
          "chat.deepseek.com"
          "chatgpt.com"
          "claude.ai"
          "github.com"
          "ar.computrabajo.com"
          "www.kimi.com"
          "www.linkedin.com"
        ];
      };

      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
  };
}
