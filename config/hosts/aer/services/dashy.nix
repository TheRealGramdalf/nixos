{config, context, ...}: let
  cfg = config.services.dashy;
  port = 6941;
in {
  services.dashy = {
    enable = true;
    virtualHost = {
      enableNginx = true;
      domain = "aer.dedyn.io";
    };
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
              description = "Scan, index, and archive physical paper documents";
              icon = "si-paperlessngx";
              title = "Paperless";
              url = "https://paperless.aer.dedyn.io";
            }
          ];
        }
        {
          name = "Media";
          displayData.hideForGuests = true;
          items = [
            {
              description = "Stream Music, Movies, and TV Shows";
              icon = "si-jellyfin";
              title = "Jellyfin";
              url = "https://media.aer.dedyn.io";
            }
            #{
            #  description = "Music Library Manager";
            #  title = "Lidarr";
            #  url = "https://lidarr.aer.dedyn.io";
            #}
            #{
            #  description = "Semi-automated Music organization/tagging";
            #  title = "OneTag";
            #  url = "https://onetag.aer.dedyn.io";
            #}
          ];
        }
        {
          name = "Identity";
          items = [
            {
              description = "Single Sign-on (Server Account)";
              title = "Kanidm";
              url = "https://auth.aer.dedyn.io";
            }
            {
              description = "Password Manager compattible with Bitwarden Clients";
              icon = "si-vaultwarden";
              title = "Vaultwarden";
              url = "${config.services.vaultwarden.config.DOMAIN}";
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
                  description = "Connecting from a Windows computer";
                  icon = "fas fa-folder-tree";
                  title = "Windows";
                  url = ''\\${config.networking.hostname}'';
                }
                {
                  description = "Connecting from a Linux device";
                  icon = "fas fa-folder-tree";
                  title = "Linux";
                  url = "smb://${config.networking.hostname}";
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
              description = "OpenWRT WebUI";
              icon = "si-openwrt";
              title = "Edge Router";
              url = "https://192.168.1.1";
            }
            {
              description = "Wireless AP for Aerwiar: Killridge Mountains";
              icon = "fas fa-wifi";
              title = "Aer: Killridge";
              url = "https://192.168.1.2";
            }
            {
              description = "Wireless AP for Aerwiar: Woes of Shreve";
              icon = "fas fa-wifi";
              title = "Aer: Woes of Shreve";
              url = "https://192.168.1.187:4343";
            }
            {
              description = "Debugging dashboard";
              icon = "si-traefikproxy";
              title = "Traefik";
              url = "https://traefik.aer.dedyn.io";
            }
            {
              description = "Dell iDrac 6 express WebUI";
              icon = "fas fa-server";
              title = "Dell iDrac";
              url = "https://192.168.1.228/start.html";
            }
          ];
        }
        #{
        #  name = "Monitoring";
        #  displayData.hideForGuests = true;
        #  items = [
        #    {
        #      description = "Data visualised on dashboards";
        #      icon = "si-grafana";
        #      title = "Grafana";
        #      url = "https://monitor.aer.dedyn.io";
        #    }
        #  ];
        #}
        #{
        #  name = "System Maintence";
        #  displayData.hideForGuests = true;
        #  items = [
        #    {
        #      description = "Real-time system resource usage";
        #      title = "NetData";
        #    }
        #    {
        #      description = "Docker container management";
        #      title = "Portainer";
        #    }
        #    {
        #      description = "Container monitoring";
        #      title = "cAdvisor";
        #    }
        #    {
        #      description = "Simple resource usage";
        #      title = "Glances";
        #    }
        #    {
        #      description = "Docker container web log viewer";
        #      title = "Dozzle";
        #    }
        #    {
        #      description = "System Statistics Aggregation with PromQL";
        #      title = "Prometheus";
        #    }
        #  ];
        #}
        {
          name = "External Services";
          displayData.hideForGuests = true;
          items = [
            {
              description = "DDNS/Domain provider";
              title = "Desec";
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
              description = "Check public IP and associated data";
              title = "Public IP";
              url = "https://ifconfig.me/";
            }
            {
              description = "Check ICAN info for a given IP address or domain";
              title = "Who Is Lookup";
              url = "https://whois.domaintools.com/";
            }
            {
              description = "Upload + download speeds and latency";
              title = "Speed Test";
              url = "https://speed.cloudflare.com/";
            }
          ];
        }
        {
          name = "Dashy";
          displayData.hideForGuests = true;
          items = [
            {
              subItems = [
                {
                  description = "Documentation for Dashy Icons";
                  icon = "si-github";
                  title = "Docs";
                  url = "https://github.com/Lissy93/dashy/blob/master/docs/icons.md";
                }
                {
                  description = "2900+ brand SVGs";
                  icon = "si-simpleicons";
                  title = "Simple Icons";
                  url = "https://simpleicons.org";
                }
                {
                  description = "Free generic SVG icons";
                  icon = "si-fontawesome";
                  title = "Font-Awesome Icons";
                  url = "https://fontawesome.com/search?o=r&m=free";
                }
              ];
              title = "Icons";
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
      middlewares = "local-only";
    };
    http.services."dashy".loadbalancer.servers = [{url = "http://127.0.0.1:${toString port}";}];
  };
}
