{context, ...}: let
  domain = "aer.dedyn.io";
  port = 6941;
  settings = {
    appConfig = {
      # Nix stuff
      disableUpdateChecks = true;
      preventWriteToDisk = true;

      allowConfigEdit = true;
      auth = {
        enableGuestAccess = false;
        enableKeycloak = false;
        users = [
          {
            hash = "416446aa03cd5d634673b505387e139e11751c3c2dfb7fa1632535ff5c2406ca";
            type = "admin";
            user = "root";
          }
        ];
      };
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
            id = "0_1302_archivebox";
            title = "Archive Box";
          }
          {
            description = "Feature-rich dynamic tables (similar to Airtable)";
            id = "1_1302_baserow";
            title = "Baserow";
          }
          {
            description = "Self-hosted Wiki";
            id = "2_1302_bookstack";
            title = "Bookstack";
          }
          {
            description = "Manage domains and other internet assets";
            id = "3_1302_domainmod";
            title = "Domain Mod";
          }
          {
            description = "Financial manager, for keeping track of expenses, income, budgets, etc";
            id = "4_1302_firefly";
            title = "Firefly";
          }
          {
            description = "RSS feed reader and news aggregator";
            id = "5_1302_freshrss";
            title = "Fresh RSS";
          }
          {
            description = "Personal GIF library";
            id = "6_1302_gifwit";
            title = "GifWit";
          }
          {
            description = "Git service, hosting mirrors of my public repos";
            id = "7_1302_gittea";
            title = "Git Tea";
          }
          {
            description = "Issues involving 'TheRealGramdalf'";
            icon = "si-github";
            id = "8_1302_githubissues";
            title = "Github Issues";
            url = "https://github.com/search?q=is%3Aissue+involves%3Atherealgramdalf&type=issues&s=updated&o=desc";
          }
          {
            description = "Cloud office suit and collaboration platform";
            id = "9_1302_nextcloud";
            title = "NextCloud";
          }
          {
            description = "Scan, index, and archive physical paper documents";
            icon = "si-paperless-ngx";
            id = "10_1302_paperless";
            title = "Paperless";
            url = "https://paperless.aer.dedyn.io";
          }
          {
            description = "Browsing, organizing, and sharing photos and albums";
            id = "11_1302_photoprism";
            title = "Photo Prism";
          }
          {
            description = "Encrypted notes app, with extensions and desktop + mobile apps";
            id = "12_1302_standardnotes";
            title = "Standard Notes";
          }
          {
            description = "Peer-to-peer file synchronization";
            id = "13_1302_syncthing";
            title = "Syncthing";
          }
          {
            description = "Cloud based VS Code development environment";
            id = "14_1302_vscodeweb";
            title = "VS Code Web";
          }
          {
            description = "Saved URLs and bookmarks";
            id = "15_1302_wallabag";
            title = "Wallabag";
          }
          {
            description = "Bookmarks, history and browser sync";
            id = "16_1302_xbrowsersync2";
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
            id = "0_1021_edgerouter";
            title = "Edge Router";
            url = "https://192.168.1.1";
          }
          {
            description = "Server firewall for incoming connections";
            icon = "si-opnsense";
            id = "1_1021_opnsense";
            title = "OPNsense";
            url = "https://gateway.aer.dedyn.io";
          }
          {
            description = "VM/LXC hypervisor";
            icon = "si-proxmox";
            id = "2_1021_proxmox";
            title = "Proxmox";
            url = "https://proxmox.aer.dedyn.io";
          }
          {
            description = "Debugging dashboard";
            icon = "si-traefikproxy";
            id = "3_1021_traefik";
            title = "Traefik";
            url = "https://traefik.aer.dedyn.io";
          }
          {
            description = "Wireless AP for Aerwiar: Killridge Mountains";
            icon = "fas fa-wifi";
            id = "4_1021_aerkillridge";
            title = "Aer: Killridge";
            url = "https://192.168.1.2";
          }
          {
            description = "Wireless AP for Aerwiar: Woes of Shreve";
            icon = "fas fa-wifi";
            id = "5_1021_aerwoesofshreve";
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
            id = "0_1062_pihole";
            title = "Pi-Hole";
          }
          {
            description = "Presence monitoring and ARP scanning";
            id = "1_1062_pialert";
            title = "PiAlert";
          }
          {
            description = "Network latency monitoring";
            id = "2_1062_smokeping";
            title = "SmokePing";
          }
          {
            description = "Up-time monitoring for local service";
            id = "3_1062_statping";
            title = "StatPing";
          }
          {
            description = "Local network speed and latency test";
            id = "4_1062_librespeed";
            title = "LibreSpeed";
          }
          {
            description = "Data visualised on dashboards";
            icon = "si-grafana";
            id = "5_1062_grafana";
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
            id = "0_1593_netdata";
            title = "NetData";
          }
          {
            description = "Docker container management";
            id = "1_1593_portainer";
            title = "Portainer";
          }
          {
            description = "Container monitoring";
            id = "2_1593_cadvisor";
            title = "cAdvisor";
          }
          {
            description = "Simple resource usage";
            id = "3_1593_glances";
            title = "Glances";
          }
          {
            description = "Docker container web log viewer";
            id = "4_1593_dozzle";
            title = "Dozzle";
          }
          {
            description = "System Statistics Aggregation with PromQL";
            id = "5_1593_prometheus";
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
            id = "0_1703_desec";
            title = "Desec";
            url = "https://desec.io/login";
          }
          {
            description = "Off-site system Borg backups";
            id = "1_1703_borgbase";
            title = "BorgBase";
            url = "https://www.borgbase.com/repositories";
          }
          {
            description = "Hosted VPN provider";
            id = "2_1703_mullvad";
            title = "Mullvad";
            url = "https://mullvad.net/en/account/";
          }
          {
            description = "Secure networks between devices";
            id = "3_1703_zerotier";
            title = "ZeroTier";
            url = "https://my.zerotier.com/";
          }
          {
            description = "Cron Job Monitoring";
            id = "4_1703_healthchecks";
            title = "HealthChecks";
            url = "https://healthchecks.io/checks/";
          }
          {
            description = "Broadband internet provider";
            id = "5_1703_ispvodafone";
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
            id = "0_480_jellyfin";
            title = "Jellyfin";
            url = "https://media.aer.dedyn.io";
          }
          {
            description = "Music Library Manager";
            id = "1_480_lidarr";
            title = "Lidarr";
            url = "https://lidarr.aer.dedyn.io";
          }
          {
            description = "Semi-automated Music organization/tagging";
            id = "2_480_onetag";
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
            id = "0_1162_homeassistant";
            title = "Home Assistant";
          }
          {
            description = "Flow-based automation";
            id = "1_1162_nodered";
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
            id = "0_1823_publicip";
            title = "Public IP";
            url = "https://www.whatismyip.com/";
          }
          {
            description = "Check ICAN info for a given IP address or domain";
            id = "1_1823_whoislookup";
            title = "Who Is Lookup";
            url = "https://whois.domaintools.com/";
          }
          {
            description = "Upload + download speeds and latency";
            id = "2_1823_speedtest";
            title = "Speed Test";
            url = "https://speed.cloudflare.com/";
          }
          {
            description = "Confirms a secure connection to Mullvad's WireGuard servers";
            id = "3_1823_mullvadcheck";
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
            id = "0_842_kanidm";
            title = "Kanidm";
            url = "https://auth.aer.dedyn.io";
          }
          {
            description = "Password Manager compattible with Bitwarden Clients";
            icon = "si-vaultwarden";
            id = "1_842_vaultwarden";
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
                id = "0_505_docs";
                title = "Docs";
                url = "https://github.com/Lissy93/dashy/blob/master/docs/icons.md";
              }
              {
                description = "2900+ brand SVGs";
                icon = "si-simpleicons";
                id = "1_505_simpleicons";
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
            inherit settings
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
