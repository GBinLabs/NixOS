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
        "privacy.trackingprotection.enabled" = true;
        "privacy.trackingprotection.fingerprinting.enabled" = true;
        "privacy.trackingprotection.cryptomining.enabled" = true;
        "privacy.trackingprotection.socialtracking.enabled" = true;
        "privacy.trackingprotection.strictLevel.enabled" = true;
        "privacy.fingerprintingProtection" = true;
        "privacy.fingerprintingProtection.pbmode" = false;
        "privacy.resistFingerprinting" = false;
        "privacy.globalprivacycontrol.enabled" = true;
        "privacy.sanitize.sanitizeOnShutdown" = true;
        "privacy.clearOnShutdown.cookies" = true;
        "privacy.clearOnShutdown.siteData" = true;
        "privacy.clearOnShutdown.siteSettings" = false;
        "network.cookie.cookieBehavior" = 5;
        "network.cookie.lifetimePolicy" = 2;
        "signon.rememberSignons" = false;
        "signon.autofillForms" = false;
        "signon.management.page.breach-alerts.enabled" = true;
        "signon.generation.enabled" = false;
        "signon.firefoxRelay.feature" = "disabled";
        "browser.formfill.enable" = false;
        "extensions.formautofill.addresses.enabled" = false;
        "extensions.formautofill.creditCards.enabled" = false;
        "browser.formfill.saveHttpsForms" = false;
        "places.history.enabled" = false;
        "privacy.clearOnShutdown.history" = true;
        "privacy.clearOnShutdown.downloads" = true;
        "privacy.clearOnShutdown.cache" = true;
        "privacy.clearOnShutdown.sessions" = true;
        "privacy.clearOnShutdown.formdata" = true;
        "privacy.clearOnShutdown.offlineapps" = true;
        "toolkit.telemetry.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.updatePing.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
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
        "dom.security.https_only_mode" = true;
        "dom.security.https_only_mode_ever_enabled" = true;
        "network.trr.mode" = 3;
        "network.trr.custom_uri" = "https://dns.quad9.net/dns-query";
        "network.trr.uri" = "https://dns.quad9.net/dns-query";
        "network.trr.confirmationNS" = "skip";
        "network.dns.skipTRR-when-parental-control-enabled" = false;
        "network.http.http3.enabled" = true;
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
        "browser.download.useDownloadDir" = false;
        "browser.download.always_ask_before_handling_new_types" = true;
        "media.eme.enabled" = true;
        "extensions.pocket.enabled" = false;
        "extensions.pocket.api" = "";
        "extensions.pocket.oAuthConsumerKey" = "";
        "extensions.pocket.site" = "";
        "identity.fxaccounts.enabled" = false;
        "browser.newtabpage.activity-stream.fxaccounts.endpoint" = "";
        "browser.in-content.dark-mode" = true;
        "ui.systemUsesDarkTheme" = 1;
        "browser.theme.toolbar-theme" = 0;
        "browser.theme.content-theme" = 0;
        "browser.tabs.tabClipWidth" = 0;
        "browser.tabs.tabMinWidth" = 76;
        "browser.display.background_color" = "#0A1019";
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "browser.toolbars.bookmarks.visibility" = "always";
        "layers.acceleration.force-enabled" = true;
        "dom.ipc.processCount" = 8;
        "gfx.webrender.all" = true;
        "browser.download.improvements_to_download_panel" = true;
        "privacy.userContext.enabled" = true;
        "privacy.userContext.ui.enabled" = true;
        "privacy.userContext.extension.enabled" = true;
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
