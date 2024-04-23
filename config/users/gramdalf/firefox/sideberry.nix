{
  config,
  lib,
  pkgs,
  ...
}: {
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
    profiles."gramdalf".settings = {
      # Bookmarks are built in to sideberry
      "browser.toolbars.bookmarks.visibility" = "never";
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      userChrome = ''
      #main-window[titlepreface*="[Sidebery]"] #navigator-toolbox {
        --toolbar-bgcolor: #242631;
        display: flex !important;
        background-color: var(--toolbar-bgcolor) !important;
      }

      #main-window[titlepreface*="[Sidebery]"] #TabsToolbar .titlebar-spacer,
      #main-window[titlepreface*="[Sidebery]"] #TabsToolbar .toolbar-items {
        display: none !important;
      }

      #main-window[titlepreface*="[Sidebery]"] #TabsToolbar .titlebar-buttonbox {
        margin-right: 12px !important;
      }

      #main-window[titlepreface*="[Sidebery]"] #nav-bar {
        flex-grow: 1 !important;
      }

      #sidebar-header {
        display: none;
      }

      #sidebar-splitter {
        --sidebar-border-color: var(--chrome-content-separator-color);
      }

      #navigator-toolbox {
        --toolbarbutton-hover-background: hsla(0, 0%, 70%, 0.2);
      }

      #urlbar-background {
        --toolbar-field-border-color: transparent;
        --toolbar-field-background-color: transparent;
        --toolbar-field-focus-border-color: #a86595;
        --toolbar-field-focus-background-color: #242631;
        --arrowpanel-border-color: #a86595;
      }
      '';
    };
  };
}

