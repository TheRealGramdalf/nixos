{
  inputs,
  pkgs,
  x-wifi-password ? "none",
  x-hashed-root-password ? "none",
  ...
}: let
  ssh-pub-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL5ibKzd+V2eR1vmvBAfSWcZmPB8zUYFMAN3FS6xY9ma";
  profiles = inputs.openwrt-imagebuilder.lib.profiles {inherit pkgs;};

  config =
    profiles.identifyProfile "creality_wb-01"
    // {
      release = "25.12.0-rc2";
      extraImageName = "klipperwrt";
      packages =
        [
          "luci" # https://github.com/astro/nix-openwrt-imagebuilder/issues/53
          #"luci-ssl" # For HTTPS support
          # For extroot:
          "block-mount"
          "kmod-fs-ext4"
          "kmod-usb-storage"
          "kmod-usb-ohci"
          "kmod-usb-uhci"
          "e2fsprogs"
          "fdisk"
          # For serving the klipper webserver
          "nginx-ssl"
          # To fetch klipper
          "git-http" # smaller than straight git
        ];
      files = pkgs.runCommand "image-files" {} ''

        

        # Add ssh key
        mkdir -p $out/etc/dropbear
        echo "${ssh-pub-key}" >> $out/etc/dropbear/authorized_keys

        # Set UCI settings
        mkdir -p $out/etc/uci-defaults
        cat > $out/etc/uci-defaults/99-custom <<EOF
          #!/usr/bin/env ash
          exec >/root/uci-defaults.log 2>&1
          uci export >> /root/uci.defaults
          uci batch << EOI
            # This is *not* referring to mDNS - it instead
            # refers to a feature in dnsmasq similar to
            # mDNS that resolves the hostnames of DHCP clients
            # as `[hostname].lan`, via regular DNS lookups.
            # Do not set this to `.local`, as that is reserved for
            # mDNS exclusively.
            #set dhcp.@dnsmasq[0].local='/lan/'
            #set dhcp.@dnsmasq[0].domain='lan'


            # Set the static address so it won't conflict
            #set network.lan.ipaddr='192.168.1.2'
            # Set the gateway and DNS server to the edge router
            #set network.lan.gateway='192.168.1.1'
            #add_list network.lan.dns='192.168.1.1'
            # Set a DNS search domain. When the OpenWrt device itself
            # resolves a (non-FQDN) hostname, it is supposed to try `dns_search`
            # `local` here refers to mDNS, whereas `lan` refers to the DNS
            # records fabricated by unbound using hostnames of DHCP clients.
            #add_list network.lan.dns_search='local'
            #add_list network.lan.dns_search='lan'

            # Set hostname, timezone
            #del system.ntp.enabled
            #del system.ntp.enable_server
            set system.@system[0].hostname='klipperwrt'
            set system.@system[0].description='OpenWRT host for Klipper'
            set system.@system[0].zonename='America/Vancouver'
            set system.@system[0].timezone='PST8PDT,M3.2.0,M11.1.0'
            #set system.@system[0].log_proto='udp'
            #set system.@system[0].conloglevel='8'
            #set system.@system[0].cronloglevel='7'

            # Disable password authentication on SSH
            set dropbear.main.PasswordAuth='off'
            set dropbear.main.RootPasswordAuth='off'


            # Redirect HTTP requests to HTTPS (LUCI)
            #set uhttpd.main.redirect_https='1'

            commit
          EOI

          # Make a backup of /etc/shadow to /etc/shadow- as per the busybox passwd convention
          #cp /etc/shadow /etc/shadow-
          # Change root password. This is escaped because nix is cool like that.
          #sed -i -e 's;^root:[\$A-z0-9]*:;root:${x-hashed-root-password}:;' /etc/shadow

        EOF
      '';
    };
in
  inputs.openwrt-imagebuilder.lib.build config
