_: {
  programs.firefox.policies = {
    AppAutoUpdate = false;
    # DisableProfileRefresh #?
    ExtensionSettings = {
      # Remember to import the default config
      "Tab-Session-Manager@sienori" = {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/tab-session-manager/latest.xpi";
        installation_mode = "force_installed";
        default_area = "menupanel";
      };
    };
  };
  programs.firefox.profiles."gramdalf" = {
    search = {
      force = true;
      default = "ddg";
      order = [
        "ddg"
      ];
      engines = {
        bing.metaData.hidden = true;
        ebay.metaData.hidden = true;
        ddg.metaData.alias = ":ddg";
        "nix-packages" = {
          name = "NixOS Search [PKGS]";
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [":np"];
        };
        "nix-options" = {
          name = "NixOS Search [OPTS]";
          urls = [
            {
              template = "https://search.nixos.org/options";
              params = [
                {
                  name = "channel";
                  value = "unstable";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [":no"];
        };
        "nix-issues" = {
          name = "Nixpkgs Issues";
          urls = [
            {
              template = "https://github.com/NixOS/nixpkgs/issues";
              params = [
                {
                  name = "q";
                  value = "is%3Aissue%20state%3Aopen%20{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [":ni"];
        };
        "nix-wiki" = {
          name = "NixOS Wiki";
          urls = [
            {
              template = "https://wiki.nixos.org/w/index.php";
              params = [
                {
                  name = "search";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          definedAliases = [":nw"];
        };
      };
    };
  };
}
