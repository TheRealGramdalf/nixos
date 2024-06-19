_: {
  programs.firefox = {
    policies = {
      AppAutoUpdate = false;
      # DisableProfileRefresh #?
      ExtensionSettings = {
        # Remember to import the default config
        "{3c078156-979c-498b-8990-85f7987dd929}" = {
          install_url = "https://addons.mozilla.org/firefox/downloads/latest/sidebery/latest.xpi";
          installation_mode = "force_installed";
          default_area = "menupanel";
        };
      };
    };
    profiles."games" = {
      settings = {
        # Bookmarks are built in to sideberry
        "browser.toolbars.bookmarks.visibility" = "never";
        # Required to enable `userChrome.css`
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome = ''
        /* Hide the native tab bar when sideberry is active */

        #main-window #titlebar {
          overflow: hidden;
          transition: height 0.3s 0.3s !important;
        }
        /* Default state: Set initial height to enable animation */
        #main-window #titlebar { height: 3em !important; }
        #main-window[uidensity="touch"] #titlebar { height: 3.35em !important; }
        #main-window[uidensity="compact"] #titlebar { height: 2.7em !important; }
        /* Hidden state: Hide native tabs strip */
        #main-window[titlepreface*="​"] #titlebar { height: 0 !important; }
        /* Hidden state: Fix z-index of active pinned tabs */
        #main-window[titlepreface*="​"] #tabbrowser-tabs { z-index: 0 !important; }
        /* Todo: make the close button (`toolbarbutton.titlebar-button.titlebar-close`) visible when native bar is disabled */

        /* Hide the sidebars' dropdown menu & splitter */
        #sidebar-splitter,
        #sidebar-header {
          display: none;
        }
      '';
    };
  };
}
