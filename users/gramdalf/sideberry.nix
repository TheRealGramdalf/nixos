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
    profiles."gramdalf" = {
      settings = {
        # Bookmarks are built in to sideberry
        "browser.toolbars.bookmarks.visibility" = "never";
        # Required to enable `userChrome.css`
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };
      userChrome = ''
        /* Hide the native tab bar when sideberry is active */
        #main-window #TabsToolbar .toolbar-items {
        overflow: unset;
        transition: height 0.3s 0.3s !important;
        }

        /* Default state: Set initial height to enable animation */
        #main-window #TabsToolbar .toolbar-items {
        height: 3em !important;
        }

        #main-window[uidensity="touch"] #TabsToolbar .toolbar-items {
        height: 3.35em !important;
        }
        #main-window[uidensity="compact"] #TabsToolbar .toolbar-items {
        height: 2.7em !important;
        }

        #main-window[uidensity="normal"] #TabsToolbar .toolbar-items {
        height: 3.11em !important;
        }

        /* Hidden state: Hide native tabs strip */
        #main-window[titlepreface="​"] #TabsToolbar .toolbar-items {
        height: 0px !important;
        }

        /* Hidden state: Fix z-index of active pinned tabs */
        #main-window[titlepreface="​"] #tabbrowser-tabs {
        z-index: 0 !important;
        }

        /* Hide the sidebars' dropdown menu & splitter */
        #sidebar-splitter,
        #sidebar-header {
          display: none;
        }
      '';
    };
  };
}
