{context, ...}: let
  domain = "aer.dedyn.io";
  port = 6941;
  settings = {
    appConfig = {
      # Nix stuff
      disableUpdateChecks = true;
      preventWriteToDisk = true;

      allowConfigEdit = true;
      #auth = {
      #  enableGuestAccess = false;
      #  enableKeycloak = false;
      #  users = [
      #    {
      #      hash = "416446aa03cd5d634673b505387e139e11751c3c2dfb7fa1632535ff5c2406ca";
      #      type = "admin";
      #      user = "root";
      #    }
      #  ];
      #};
      defaultIcon = "generative";
      defaultOpeningMethod = "newtab";
      disableConfiguration = false;
      disableConfigurationForNonAdmin = true;
      disableContextMenu = false;
      disableSmartSort = false;
      enableErrorReporting = true;
      enableFontAwesome = true;
      enableMaterialDesignIcons = false;
      enableMultiTasking = false;
      enableServiceWorker = false;
      faviconApi = "allesedv";
      hideComponents = {
        hideFooter = false;
        hideHeading = false;
        hideNav = false;
        hideSearch = false;
        hideSettings = false;
      };
      iconSize = "medium";
      language = "en";
      layout = "auto";
      preventLocalSave = false;
      routingMode = "history";
      showSplashScreen = true;
      startingView = "default";
      statusCheck = false;
      statusCheckInterval = 0;
      theme = "argon";
      webSearch = {
        disableWebSearch = false;
        openingMethod = "newtab";
        searchBangs = {};
        searchEngine = "duckduckgo";
      };
      widgetsAlwaysUseProxy = false;
    };
    pageInfo = {
      title = "Aerwiar";
      description = "Launchpad for the Aerwiar home server";
    };
    sections = [
      {
        displayData = {
          collapsed = false;
          cols = 2;
        };
        items = [
          {
            description = "Web site archiving";
            title = "Archive Box";
          }
          {
            description = "Feature-rich dynamic tables (similar to Airtable)";
            title = "Baserow";
          }
          {
            description = "Self-hosted Wiki";
            title = "Bookstack";
          }
          {
            description = "Manage domains and other internet assets";
            title = "Domain Mod";
          }
          {
            description = "Financial manager, for keeping track of expenses, income, budgets, etc";
            title = "Firefly";
          }
          {
            description = "RSS feed reader and news aggregator";
            title = "Fresh RSS";
          }
          {
            description = "Personal GIF library";
            title = "GifWit";
          }
          {
            description = "Git service, hosting mirrors of my public repos";
            title = "Git Tea";
          }
          {
            description = "Issues involving 'TheRealGramdalf'";
            icon = "si-github";
            title = "Github Issues";
            url = "https://github.com/search?q=is%3Aissue+involves%3Atherealgramdalf&type=issues&s=updated&o=desc";
          }
          {
            description = "Cloud office suit and collaboration platform";
            title = "NextCloud";
          }
          {
            description = "Scan, index, and archive physical paper documents";
            icon = "si-paperless-ngx";
            title = "Paperless";
            url = "https://paperless.aer.dedyn.io";
          }
          {
            description = "Browsing, organizing, and sharing photos and albums";
            title = "Photo Prism";
          }
          {
            description = "Encrypted notes app, with extensions and desktop + mobile apps";
            title = "Standard Notes";
          }
          {
            description = "Peer-to-peer file synchronization";
            title = "Syncthing";
          }
          {
            description = "Cloud based VS Code development environment";
            title = "VS Code Web";
          }
          {
            description = "Saved URLs and bookmarks";
            title = "Wallabag";
          }
          {
            description = "Bookmarks, history and browser sync";
            title = "XBrowserSync";
          }
        ];
        name = "Productivity";
      }
      {
        displayData = {
          collapsed = false;
          cols = 1;
          hideForGuests = true;
          rows = 1;
          sortBy = "default";
        };
        items = [
          {
            description = "OpenWRT WebUI";
            icon = "si-openwrt";
            title = "Edge Router";
            url = "https://192.168.1.1";
          }
          {
            description = "Server firewall for incoming connections";
            icon = "si-opnsense";
            title = "OPNsense";
            url = "https://gateway.aer.dedyn.io";
          }
          {
            description = "VM/LXC hypervisor";
            icon = "si-proxmox";
            title = "Proxmox";
            url = "https://proxmox.aer.dedyn.io";
          }
          {
            description = "Debugging dashboard";
            icon = "si-traefikproxy";
            title = "Traefik";
            url = "https://traefik.aer.dedyn.io";
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
            url = "";
          }
        ];
        name = "Management";
      }
      {
        displayData = {
          collapsed = false;
          cols = 1;
          hideForGuests = true;
          rows = 1;
          sortBy = "default";
        };
        items = [
          {
            description = "DNS settings for ad & tracker blocking";
            title = "Pi-Hole";
          }
          {
            description = "Presence monitoring and ARP scanning";
            title = "PiAlert";
          }
          {
            description = "Network latency monitoring";
            title = "SmokePing";
          }
          {
            description = "Up-time monitoring for local service";
            title = "StatPing";
          }
          {
            description = "Local network speed and latency test";
            title = "LibreSpeed";
          }
          {
            description = "Data visualised on dashboards";
            icon = "si-grafana";
            title = "Grafana";
            url = "https://monitor.aer.dedyn.io";
          }
        ];
        name = "Monitoring";
      }
      {
        displayData = {
          hideForGuests = true;
          sortBy = "default";
        };
        items = [
          {
            description = "Real-time system resource usage";
            title = "NetData";
          }
          {
            description = "Docker container management";
            title = "Portainer";
          }
          {
            description = "Container monitoring";
            title = "cAdvisor";
          }
          {
            description = "Simple resource usage";
            title = "Glances";
          }
          {
            description = "Docker container web log viewer";
            title = "Dozzle";
          }
          {
            description = "System Statistics Aggregation with PromQL";
            title = "Prometheus";
          }
        ];
        name = "System Maintence";
      }
      {
        displayData = {
          hideForGuests = true;
          sortBy = "default";
        };
        items = [
          {
            description = "DDNS/Domain provider";
            title = "Desec";
            url = "https://desec.io/login";
          }
          {
            description = "Off-site system Borg backups";
            title = "BorgBase";
            url = "https://www.borgbase.com/repositories";
          }
          {
            description = "Hosted VPN provider";
            title = "Mullvad";
            url = "https://mullvad.net/en/account/";
          }
          {
            description = "Secure networks between devices";
            title = "ZeroTier";
            url = "https://my.zerotier.com/";
          }
          {
            description = "Cron Job Monitoring";
            title = "HealthChecks";
            url = "https://healthchecks.io/checks/";
          }
          {
            description = "Broadband internet provider";
            title = "ISP - Vodafone";
            url = "https://myaccount.vodafone.co.uk/";
          }
        ];
        name = "External Services";
      }
      {
        displayData = {
          hideForGuests = true;
          sortBy = "default";
        };
        items = [
          {
            description = "Stream Music, Movies, and TV Shows";
            icon = "si-jellyfin";
            title = "Jellyfin";
            url = "https://media.aer.dedyn.io";
          }
          {
            description = "Music Library Manager";
            title = "Lidarr";
            url = "https://lidarr.aer.dedyn.io";
          }
          {
            description = "Semi-automated Music organization/tagging";
            title = "OneTag";
            url = "https://onetag.aer.dedyn.io";
          }
        ];
        name = "Media";
      }
      {
        displayData = {
          hideForGuests = true;
          sortBy = "default";
        };
        items = [
          {
            description = "Smart home control";
            title = "Home Assistant";
          }
          {
            description = "Flow-based automation";
            title = "Node-RED";
          }
        ];
        name = "Home Control";
      }
      {
        displayData = {
          collapsed = true;
          hideForGuests = true;
          sortBy = "default";
        };
        items = [
          {
            description = "Check public IP and associated data";
            title = "Public IP";
            url = "https://www.whatismyip.com/";
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
          {
            description = "Confirms a secure connection to Mullvad's WireGuard servers";
            title = "Mullvad Check";
            url = "https://mullvad.net/check";
          }
        ];
        name = "External Utilities";
      }
      {
        displayData = {
          collapsed = false;
          cols = 1;
          hideForGuests = true;
          rows = 1;
          sortBy = "default";
        };
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
            url = "https://vault.aer.dedyn.io";
          }
        ];
        name = "Identity";
      }
      {
        displayData = {
          collapsed = false;
          cols = 1;
          hideForGuests = true;
          rows = 1;
          sortBy = "default";
        };
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
            ];
            title = "Icons";
          }
        ];
        name = "Dashy";
      }
    ];
  };
in {
  services.nginx = {
    enable = true;
    virtualHosts."${domain}" = {
      listen = [
        {
          addr = "127.0.0.1";
          inherit port;
        }
      ];
      locations = {
        "/" = {
          root = context.self.packages.x86_64-linux.dashy-ui.override {
            inherit settings;
          };
          tryFiles = "$uri /index.html ";
        };
      };
    };
  };
  services.cone.extraFiles."dashy".settings = {
    http.routers."dashy" = {
      rule = "Host(`${domain}`)";
      service = "dashy";
      middlewares = "local-only";
    };
    http.services."dashy".loadbalancer.servers = [{url = "http://127.0.0.1:${toString port}";}];
  };
}
