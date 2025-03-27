{
  inputs,
  pkgs,
  x-wifi-password ? "none",
  x-hashed-root-password ? "none",
  ...
}: let
  ssh-pub-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL5ibKzd+V2eR1vmvBAfSWcZmPB8zUYFMAN3FS6xY9ma";

  argon = {
    ipk = builtins.fetchurl {
      url = "https://github.com/jerrykuku/luci-theme-argon/releases/download/v2.3.2/luci-theme-argon_2.3.2-r20250207_all.ipk";
      sha256 = "sha256:0csaa17wln1sy4x6v7dj2w6ly7v8s7xznxwhgb411mll1yxycdl8";
    };
    config-ipk = builtins.fetchurl {
      url = "https://github.com/jerrykuku/luci-app-argon-config/releases/download/v0.9/luci-app-argon-config_0.9_all.ipk";
      sha256 = "sha256:1mgz9a3b51m0mwr36y4105wfmqk97gnw0ilrx85df0fd6ddhb35x";
    };
    deps = [
      "luci-compat"
      "luci-lib-ipkg"
      "luci-lua-runtime"
      "curl"
    ];
    backgrounds = builtins.concatStringsSep " " [
      ./backgrounds/dragon-prince-3.jpg
      ./backgrounds/dragon-prince-4.jpg
    ];
  };

  profiles = inputs.openwrt-imagebuilder.lib.profiles {inherit pkgs;};

  config =
    profiles.identifyProfile "linksys_wrt1900ac-v1"
    // {
      release = "24.10.0";
      extraImageName = "killridge-ap";
      packages =
        [
          "luci" # https://github.com/astro/nix-openwrt-imagebuilder/issues/53
          "luci-ssl" # For HTTPS support
          "iperf3"
          "luci-app-advanced-reboot"
          "luci-app-wifischedule"
        ]
        ++ argon.deps;
      files = pkgs.runCommand "image-files" {} ''

        ## Sub-optimally add extra ipk files to install (this takes up unneeded space)
        mkdir -p $out/root/extraPackages
        cp ${argon.ipk} $out/root/extraPackages/
        cp ${argon.config-ipk} $out/root/extraPackages/

        # Add argon backgrounds
        mkdir -p $out/www/luci-static/argon/background
        cp ${argon.backgrounds} $out/www/luci-static/argon/background/

        # Add ssh key
        mkdir -p $out/etc/dropbear
        echo "${ssh-pub-key}" >> $out/etc/dropbear/authorized_keys

        # Set UCI settings
        mkdir -p $out/etc/uci-defaults
        cat > $out/etc/uci-defaults/99-custom <<EOF
          #!/usr/bin/env ash
          exec >/root/uci-defaults.log 2>&1
          opkg install /root/extraPackages/*.ipk
          uci export >> /root/uci.defaults
          uci batch << EOI

            # Remove wan dhcp config
            del dhcp.wan
            # Set dhcp settings for LAN
            # Disable IPv6 DHCP services
            del dhcp.lan.ra
            del dhcp.lan.dhcpv6
            del dhcp.lan.ra_slaac
            # Disable IPv4 DHCP services
            set dhcp.lan.ignore='1'
            del dhcp.@dnsmasq[0].authoritative
            del dhcp.@dnsmasq[0].nonwildcard
            del dhcp.@dnsmasq[0].boguspriv
            del dhcp.@dnsmasq[0].filterwin2k
            del dhcp.@dnsmasq[0].filter_aaaa
            del dhcp.@dnsmasq[0].filter_a
            del dhcp.@dnsmasq[0].nonegcache
            # This is *not* referring to mDNS - it instead
            # refers to a feature in dnsmasq similar to
            # mDNS that resolves the hostnames of DHCP clients
            # as `[hostname].lan`, via regular DNS lookups.
            # Do not set this to `.local`, as that is reserved for
            # mDNS exclusively.
            set dhcp.@dnsmasq[0].local='/lan/'
            set dhcp.@dnsmasq[0].domain='lan'

            # Remove the WAN firewall zone
            del firewall.@zone[1]

            # Delete the WAN/WAN6 interfaces
            del network.wan
            del network.wan6

            # Set the static address so it won't conflict
            set network.lan.ipaddr='192.168.1.2'
            # Set the gateway and DNS server to the edge router
            set network.lan.gateway='192.168.1.1'
            add_list network.lan.dns='192.168.1.1'
            # Set a DNS search domain. This (appears to?) merely indicates (via DHCP)
            # that clients should use these two domains when attempting to qualify
            # a hostname that is not already qualified.
            # `local` here refers to mDNS, whereas `lan` refers to the DNS
            # records fabricated by dnsmasq using hostnames of DHCP clients.
            add_list network.lan.dns_search='local'
            add_list network.lan.dns_search='lan'

            # Add the WAN port to the lan bridge
            del network.@device[0].ports
            add_list network.@device[0].ports='lan1'
            add_list network.@device[0].ports='lan2'
            add_list network.@device[0].ports='lan3'
            add_list network.@device[0].ports='lan4'
            add_list network.@device[0].ports='wan'
            set network.globals.packet_steering='1'


            # Set hostname, timezone
            del system.ntp.enabled
            del system.ntp.enable_server
            set system.@system[0].hostname='killridge'
            set system.@system[0].description='Wireless AP running OpenWRT'
            set system.@system[0].zonename='America/Vancouver'
            set system.@system[0].timezone='PST8PDT,M3.2.0,M11.1.0'
            set system.@system[0].log_proto='udp'
            set system.@system[0].conloglevel='8'
            set system.@system[0].cronloglevel='7'

            # WiFi
            # sae-mixed is WPA2/WPA3 mixed mode
            set wireless.radio0.htmode='HT20'
            set wireless.radio0.country='CA'
            set wireless.radio0.cell_density='0'
            set wireless.radio0.channel='auto'
            set wireless.default_radio0.ssid='Aerwiar - Killridge Mountains'
            set wireless.default_radio0.encryption='sae-mixed'
            set wireless.default_radio0.key='${x-wifi-password}'
            set wireless.default_radio0.ocv='0'

            set wireless.radio1.country='CA'
            set wireless.radio1.cell_density='0'
            set wireless.radio1.channel='auto'
            set wireless.default_radio1.ssid='Aerwiar - Killridge Mountains'
            set wireless.default_radio1.encryption='sae-mixed'
            set wireless.default_radio1.key='${x-wifi-password}'
            set wireless.default_radio1.ocv='0'

            # Enable WiFi
            del wireless.radio1.disabled='0'
            del wireless.radio0.disabled='0'

            # Set wifi schedule
            set wifi_schedule.@global[0].enabled='1'
            set wifi_schedule.@global[0].unload_modules='0'
            set wifi_schedule.Businesshours.enabled='1'
            set wifi_schedule.Businesshours.starttime='07:00'
            set wifi_schedule.Businesshours.stoptime='21:00'
            set wifi_schedule.Businesshours.forcewifidown='1'
            set wifi_schedule.Weekend.enabled='1'
            set wifi_schedule.Weekend.starttime='08:00'
            set wifi_schedule.Weekend.stoptime='21:00'
            set wifi_schedule.Weekend.forcewifidown='1'

            # Disable password authentication on SSH
            set dropbear.main.PasswordAuth='off'
            set dropbear.main.RootPasswordAuth='off'


            # Redirect HTTP requests to HTTPS (LUCI)
            set uhttpd.main.redirect_https='1'

            # Set argon to dark mode
            set argon.@global[0].mode='dark'


            commit
          EOI

          # Make a backup of /etc/shadow to /etc/shadow- as per the busybox passwd convention
          cp /etc/shadow /etc/shadow-
          # Change root password. This is escaped because nix is cool like that.
          sed -i -e 's;^root:[\$A-z0-9]*:;root:${x-hashed-root-password}:;' /etc/shadow

        EOF
      '';
    };
in
  inputs.openwrt-imagebuilder.lib.build config
