{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.firefox = {
    enable = true;
    policies = {
      DNSOverHTTPS = {Enabled = false;};
      DisableAppUpdate = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      NetworkPrediction = false;
      "3rdparty".Extensions = {
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          # Bitwarden
          environment.base = "https://vault.aer.dedyn.io";
        };
      };
      ExtensionSettings = {
        "CanvasBlocker@kkapsner.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/canvasblocker/latest.xpi";
          installation_mode = "force_installed";
          default_area = "menupanel";
        };
        "ClearURLs@kevinr" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/clearurls/latest.xpi";
          installation_mode = "force_installed";
          default_area = "menupanel";
        };
        "treestyletab@piro.sakura.ne.jp" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/tree-style-tab/latest.xpi";
          installation_mode = "force_installed";
          default_area = "menupanel";
        };
        "{ce9f4b1f-24b8-4e9a-9051-b9e472b1b2f2}" = {
          # Clear browsing data
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/clear-browsing-data/latest.xpi";
          installation_mode = "force_installed";
          default_area = "menupanel";
        };
        "Tab-Session-Manager@sienori" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/tab-session-manager/latest.xpi";
          installation_mode = "force_installed";
          default_area = "menupanel";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          # Bitwarden
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };
        "uBlock0@raymondhill.net" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };
        "addon@darkreader.org" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
          installation_mode = "force_installed";
          default_area = "navbar";
        };
      };
    };
    profiles."gramdalf" = {
      isDefault = true;
      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      extraConfig = ''
        user_pref("app.normandy.api_url", "");
        user_pref("app.normandy.enabled", false);
        user_pref("app.shield.optoutstudies.enabled", false);
        user_pref("app.update.auto", false);
        user_pref("beacon.enabled", false);
        user_pref("breakpad.reportURL", "");
        user_pref("browser.aboutConfig.showWarning", false);
        user_pref("browser.crashReports.unsubmittedCheck.autoSubmit", false);
        user_pref("browser.crashReports.unsubmittedCheck.autoSubmit2", false);
        user_pref("browser.crashReports.unsubmittedCheck.enabled", false);
        user_pref("browser.disableResetPrompt", true);
        user_pref("browser.fixup.alternate.enabled", false);
        user_pref("browser.newtab.preload", false);
        user_pref("browser.newtabpage.activity-stream.feeds.section.topstories", false);
        user_pref("browser.newtabpage.activity-stream.feeds.topsites", false);
        user_pref("browser.newtabpage.activity-stream.section.highlights.includePocket", false);
        user_pref("browser.newtabpage.enhanced", false);
        user_pref("browser.newtabpage.introShown", true);
        user_pref("browser.safebrowsing.appRepURL", "");
        user_pref("browser.safebrowsing.blockedURIs.enabled", false);
        user_pref("browser.safebrowsing.downloads.enabled", false);
        user_pref("browser.safebrowsing.downloads.remote.enabled", false);
        user_pref("browser.safebrowsing.downloads.remote.url", "");
        user_pref("browser.safebrowsing.enabled", false);
        user_pref("browser.safebrowsing.malware.enabled", false);
        user_pref("browser.safebrowsing.phishing.enabled", false);
        user_pref("browser.search.suggest.enabled", false);
        user_pref("browser.selfsupport.url", "");
        user_pref("browser.send_pings", false);
        user_pref("browser.sessionstore.privacy_level", 0);
        user_pref("browser.shell.checkDefaultBrowser", false);
        user_pref("browser.startup.homepage_override.mstone", "ignore");
        user_pref("browser.tabs.crashReporting.sendReport", false);
        user_pref("browser.urlbar.groupLabels.enabled", false);
        user_pref("browser.urlbar.quicksuggest.enabled", false);
        user_pref("browser.urlbar.speculativeConnect.enabled", false);
        user_pref("browser.urlbar.trimURLs", false);
        user_pref("datareporting.healthreport.service.enabled", false);
        user_pref("datareporting.healthreport.uploadEnabled", false);
        user_pref("datareporting.policy.dataSubmissionEnabled", false);
        user_pref("device.sensors.ambientLight.enabled", false);
        user_pref("device.sensors.enabled", false);
        user_pref("device.sensors.motion.enabled", false);
        user_pref("device.sensors.orientation.enabled", false);
        user_pref("device.sensors.proximity.enabled", false);
        user_pref("dom.battery.enabled", false);
        user_pref("dom.security.https_only_mode", true);
        user_pref("dom.security.https_only_mode_ever_enabled", true);
        user_pref("dom.webaudio.enabled", false);
        user_pref("experiments.activeExperiment", false);
        user_pref("experiments.enabled", false);
        user_pref("experiments.manifest.uri", "");
        user_pref("experiments.supported", false);
        user_pref("extensions.ClearURLs@kevinr.whiteList", "");
        user_pref("extensions.autoDisableScopes", 14);
        user_pref("extensions.getAddons.cache.enabled", false);
        user_pref("extensions.getAddons.showPane", false);
        user_pref("extensions.greasemonkey.stats.optedin", false);
        user_pref("extensions.greasemonkey.stats.url", "");
        user_pref("extensions.pocket.enabled", false);
        user_pref("extensions.shield-recipe-client.api_url", "");
        user_pref("extensions.shield-recipe-client.enabled", false);
        user_pref("extensions.webservice.discoverURL", "");
        user_pref("keyword.enabled", false);
        user_pref("media.autoplay.default", 0);
        user_pref("media.autoplay.enabled", true);
        user_pref("media.eme.enabled", false);
        user_pref("media.gmp-widevinecdm.enabled", false);
        user_pref("media.navigator.enabled", false);
        user_pref("media.video_stats.enabled", false);
        user_pref("network.IDN_show_punycode", true);
        user_pref("network.allow-experiments", false);
        user_pref("network.cookie.cookieBehavior", 1);
        user_pref("network.dns.disablePrefetch", true);
        user_pref("network.dns.disablePrefetchFromHTTPS", true);
        user_pref("network.http.referer.XOriginPolicy", 2);
        user_pref("network.http.speculative-parallel-limit", 0);
        user_pref("network.predictor.enable-prefetch", false);
        user_pref("network.predictor.enabled", false);
        user_pref("network.prefetch-next", false);
        user_pref("network.trr.mode", 5);
        user_pref("privacy.donottrackheader.enabled", true);
        user_pref("privacy.donottrackheader.value", 1);
        user_pref("privacy.firstparty.isolate", true);
        user_pref("privacy.query_stripping", true);
        user_pref("privacy.trackingprotection.cryptomining.enabled", true);
        user_pref("privacy.trackingprotection.enabled", true);
        user_pref("privacy.trackingprotection.fingerprinting.enabled", true);
        user_pref("privacy.trackingprotection.pbmode.enabled", true);
        user_pref("privacy.usercontext.about_newtab_segregation.enabled", true);
        user_pref("security.ssl.disable_session_identifiers", true);
        user_pref("services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite", false);
        user_pref("signon.autofillForms", false);
        user_pref("toolkit.telemetry.archive.enabled", false);
        user_pref("toolkit.telemetry.bhrPing.enabled", false);
        user_pref("toolkit.telemetry.cachedClientID", "");
        user_pref("toolkit.telemetry.enabled", false);
        user_pref("toolkit.telemetry.firstShutdownPing.enabled", false);
        user_pref("toolkit.telemetry.hybridContent.enabled", false);
        user_pref("toolkit.telemetry.newProfilePing.enabled", false);
        user_pref("toolkit.telemetry.prompted", 2);
        user_pref("toolkit.telemetry.rejected", true);
        user_pref("toolkit.telemetry.reportingpolicy.firstRun", false);
        user_pref("toolkit.telemetry.server", "");
        user_pref("toolkit.telemetry.shutdownPingSender.enabled", false);
        user_pref("toolkit.telemetry.unified", false);
        user_pref("toolkit.telemetry.unifiedIsOptIn", false);
        user_pref("toolkit.telemetry.updatePing.enabled", false);
        user_pref("webgl.renderer-string-override", " ");
        user_pref("webgl.vendor-string-override", " ");
      '';
    };
  };

  # https://stackoverflow.com/questions/53658303/fetchfromgithub-filter-down-and-use-as-environment-etc-file-source

  #home.file.".mozilla/firefox/gramdalf/chrome".source = pkgs.fetchFromGitHub {
  #  owner = "soulhotel";
  #  repo = "FF-ULTIMA";
  #  rev = "1.6.8";
  #  hash = "sha256-q+AyJF1cocyh2zWmp0VbLmduLbJqcfKQVbWlHUjCm5A=";
  #};
}
