{config, ...}: let
  cfg = config.services.dashy;
  port = 6941;
in {
  services.dashy = {
    enable = true;
    virtualHost = {
      enableNginx = true;
      domain = "aer.dedyn.io";
    };
    #package = inputs.self.packages.x86_64-linux.dashy-ui;
    settings = {
      pageInfo = {
        title = "Aerwiar";
        description = "Launchpad for the Aerwiar home server";
      };
      appConfig = {
        ## Nix stuff, should probably go in default module if possible
        disableUpdateChecks = true;
        preventWriteToDisk = true;

        ## Config related settings
        enableErrorReporting = false;
        allowConfigEdit = true;
        preventLocalSave = false;
        disableConfigurationForNonAdmin = true;
        disableConfiguration = false;
        #auth = {
        #  enableGuestAccess = true;
        #  enableOidc = true;
        #  oidc = {
        #    clientId = "";
        #    endpoint = "";
        #  }
        #  users = [
        #    {
        #      hash = "416446aa03cd5d634673b505387e139e11751c3c2dfb7fa1632535ff5c2406ca";
        #      type = "admin";
        #      user = "root";
        #    }
        #  ];
        #};
        ## Functionality
        routingMode = "history";
        statusCheck = false;
        statusCheckInterval = 0;
        webSearch = {
          disableWebSearch = false;
          openingMethod = "newtab";
          searchBangs = {};
          searchEngine = "duckduckgo";
        };
        defaultOpeningMethod = "newtab";
        # Not sure about my verdict on multitasking yet
        enableMultiTasking = false;
        # Offline dashboard is nice, ctrl + f5 will force reload if needed
        enableServiceWorker = true;
        faviconApi = "allesedv";
        ## UI settings
        theme = "argon";
        showSplashScreen = false;
        iconSize = "medium";
        # Use a handy generative icon if none is specified
        defaultIcon = "generative";
        layout = "auto";
        startingView = "default";
        language = "en";
        hideComponents = {
          hideFooter = true;
          hideHeading = false;
          hideNav = false;
          hideSearch = false;
          hideSettings = false;
        };
      };
      sections = [
        {
          name = "Productivity";
          items = [
            {
              title = "Paperless";
              description = "Scan, index, and archive physical paper documents";
              icon = "si-paperlessngx";
              url = "https://paperless.aer.dedyn.io";
            }
          ];
        }
        {
          name = "Media";
          displayData.hideForGuests = true;
          items = [
            {
              title = "Jellyfin";
              description = "Stream Music, Movies, and TV Shows";
              icon = "si-jellyfin";
              url = "https://media.aer.dedyn.io";
            }
            #{
            #  title = "Lidarr";
            #  description = "Music Library Manager";
            #  url = "https://lidarr.aer.dedyn.io";
            #}
            #{
            #  title = "OneTag";
            #  description = "Semi-automated Music organization/tagging";
            #  url = "https://onetag.aer.dedyn.io";
            #}
          ];
        }
        {
          name = "Automation";
          displayData.hideForGuests = true;
          items = [
            {
              title = "Home Assistant";
              description = "Home automation platform with thousands of integrations";
              icon = "si-homeassistant";
              url = "https://home.aer.dedyn.io/auth/oidc/redirect";
            }
          ];
        }
        {
          name = "Identity";
          items = [
            {
              title = "Kanidm";
              description = "Single Sign-on (Server Account)";
              icon = "fas fa-lock";
              url = "${config.services.kanidm.serverSettings.origin}";
            }
            {
              title = "Vaultwarden";
              description = "Password Manager compattible with Bitwarden Clients";
              icon = "si-vaultwarden";
              url = "${config.services.vaultwarden.config.DOMAIN}";
            }
            {
              title = "Bitwarden Clients";
              subItems = [
                {
                  title = "How to connect to the official Bitwarden clients";
                  icon = "fas fa-question";
                  target = "newtab";
                  # Sourced from https://bitwarden.com/help/change-client-environment/
                  url = "https://bitwarden.com/pdf/help-change-client-environment.pdf";
                }
                {
                  title = "Click to copy the Server URL needed for the Bitwarden clients";
                  icon = "fas fa-copy";
                  target = "clipboard";
                  url = "${config.services.vaultwarden.config.DOMAIN}";
                }
              ];
            }
          ];
        }
        {
          name = "Connectivity";
          items = [
            {
              title = "Netbird VPN";
              icon = "fas fa-network-wired";
              url = "https://${config.services.netbird.server.domain}";
            }
            {
              title = "Network Shares";
              subItems = [
                {
                  title = "Windows";
                  #description = "Connecting from a Windows computer";
                  icon = "fas fa-folder-tree";
                  target = "clipboard";
                  url = ''\\${config.networking.hostName}'';
                }
                {
                  title = "Linux";
                  #description = "Connecting from a Linux device";
                  icon = "fas fa-folder-tree";
                  target = "clipboard";
                  url = "smb://${config.networking.hostName}";
                }
              ];
            }
          ];
        }
        {
          name = "Management";
          displayData.hideForGuests = true;
          items = [
            {
              title = "Edge Router";
              description = "OPNSense WebUI";
              icon = "si-opnsense";
              url = "https://192.168.1.1";
            }
            {
              title = "Aer: Killridge";
              description = "Wireless AP for Aerwiar: Killridge Mountains";
              icon = "fas fa-wifi";
              url = "https://192.168.1.2";
            }
            {
              title = "Aer: Woes of Shreve";
              description = "Wireless AP for Aerwiar: Woes of Shreve";
              icon = "fas fa-wifi";
              url = "https://woes";
            }
            {
              title = "Aer: Peet's Castle";
              description = "Wireless AP for Aerwiar: Woes of Shreve";
              icon = "fas fa-wifi";
              url = "https://192.168.1.6";
            }
            {
              title = "Traefik";
              description = "Debugging dashboard";
              icon = "si-traefikproxy";
              url = "https://traefik.aer.dedyn.io";
            }
            {
              title = "Dell iDrac";
              description = "Dell iDrac 6 express WebUI";
              icon = "fas fa-server";
              url = "https://192.168.1.228/start.html";
            }
          ];
        }
        #{
        #  name = "Monitoring";
        #  displayData.hideForGuests = true;
        #  items = [
        #    {
        #      title = "Grafana";
        #      description = "Data visualised on dashboards";
        #      icon = "si-grafana";
        #      url = "https://monitor.aer.dedyn.io";
        #    }
        #  ];
        #}
        #{
        #  name = "System Maintence";
        #  displayData.hideForGuests = true;
        #  items = [
        #    {
        #      title = "NetData";
        #      description = "Real-time system resource usage";
        #    }
        #    {
        #      title = "cAdvisor";
        #      description = "Container monitoring";
        #    }
        #    {
        #      title = "Glances";
        #      description = "Simple resource usage";
        #    }
        #    {
        #      title = "Dozzle";
        #      description = "Docker container web log viewer";
        #    }
        #    {
        #      title = "Prometheus";
        #      description = "System Statistics Aggregation with PromQL";
        #    }
        #  ];
        #}
        {
          name = "External Services";
          displayData.hideForGuests = true;
          items = [
            {
              title = "Desec";
              description = "DDNS/Domain provider";
              url = "https://desec.io/login";
            }
          ];
        }
        {
          name = "External Utilities";
          displayData = {
            collapsed = true;
            hideForGuests = true;
          };
          items = [
            {
              title = "Public IP";
              description = "Check public IP and associated data";
              url = "https://ifconfig.me/";
            }
            {
              title = "Who Is Lookup";
              description = "Check ICAN info for a given IP address or domain";
              url = "https://whois.domaintools.com/";
            }
            {
              title = "Speed Test";
              description = "Upload + download speeds and latency";
              url = "https://speed.cloudflare.com/";
            }
          ];
        }
        {
          name = "Dashy";
          displayData.hideForGuests = true;
          items = [
            {
              title = "Icons";
              subItems = [
                {
                  title = "Docs";
                  #description = "Documentation for Dashy Icons";
                  icon = "si-github";
                  url = "https://github.com/Lissy93/dashy/blob/master/docs/icons.md";
                }
                {
                  title = "Simple Icons";
                  #description = "2900+ brand SVGs";
                  icon = "si-simpleicons";
                  url = "https://simpleicons.org";
                }
                {
                  title = "Font-Awesome Icons";
                  description = "Free generic SVG icons";
                  icon = "si-fontawesome";
                  url = "https://fontawesome.com/search?ic=free";
                }
              ];
            }
          ];
        }
      ];
    };
  };

  # Add a listen address for nginx
  services.nginx.virtualHosts."${cfg.virtualHost.domain}".listen = [
    {
      addr = "127.0.0.1";
      inherit port;
    }
  ];
  # Proxy nginx through traefik
  services.cone.extraFiles."dashy".settings = {
    http.routers."dashy" = {
      rule = "Host(`${cfg.virtualHost.domain}`)";
      service = "dashy";
      #middlewares = "local-only";
    };
    http.services."dashy".loadbalancer.servers = [{url = "http://127.0.0.1:${toString port}";}];
  };
}
