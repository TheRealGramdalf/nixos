{
  inputs,
  pkgs,
  x-wifi-password ? "none",
  x-hashed-root-password ? "none",
  ...
}: let
  ssh-pub-key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL5ibKzd+V2eR1vmvBAfSWcZmPB8zUYFMAN3FS6xY9ma";
  release = "25.12.0-rc2";

  config =
    (inputs.openwrt-imagebuilder.lib.profiles {inherit release pkgs;}).identifyProfile "creality_wb-01"
    // {
      inherit release;
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
          # git can't fetch by http without this
          "git-http"
        ];
      ## NOTE TO SELF
      # When using wifi as a client (station mode) on the wb-01, it can't be on a bridge with eth0.
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
            # Lower log buffer size, and write logs to RAM instead
            # This helps reduce writes to the micro SD card and keep CPU usage down
            system.@system[0].log_file='/tmp/system.log'
            system.@system[0].log_size='16'

            # Set countrycode for proper wireless bands
            set wireless.radio0.country='CA'

            # Set the static address so it won't conflict with most setups
            del network.lan.ipaddr
            add_list network.lan.ipaddr='192.168.42.1/24'
            # Something about ipv6?
            del dhcp.lan.ra_slaac
            set dhcp.lan.ra_preference='medium'

            ## Adding a wlan interface
            # Create an interface for wireless
            set network.wlan='interface'
            set network.wlan.proto='dhcp'

            # Add the wlan iface to the lan firewall zone
            add_list firewall.@zone[0].network='wlan'

            # Set a dhcp server for wlan, but ensure that it is disabled
            # If there is no dhcp section for wlan, it could be activated accidentally (probably?)
            set dhcp.wlan='dhcp'
            set dhcp.wlan.interface='wlan'
            set dhcp.wlan.ignore='1'

            # When doing this from the UI it enables packet steering:
            set network.globals.packet_steering='1'
            


            # Set wifi to station

            # Channel width 20 -> 40 
            set wireless.radio0.htmode='HT40'
            # Auto select channel
            set wireless.radio0.channel='auto'
            set wireless.radio0.cell_density='0'
            set wireless.default_radio0.mode='sta'
            # sae-mixed is wpa2/wpa3 mixed, this should work for almost all cases
            set wireless.default_radio0.encryption='sae-mixed'
            # Operating channel verification, part of wpa2/wpa3 mixed mode. Disabled.
            set wireless.default_radio0.ocv='0'
            # Assign the radio to the wlan interface
            set wireless.default_radio0.network='wlan'

            # Enable the wifi network:
            del wireless.radio0.disabled='0'
            del wireless.default_radio0.disabled='1'

            # Set wireless network info
            set wireless.default_radio0.ssid='aerwiar-iotlan'
            set wireless.default_radio0.bssid='00:25:9C:13:7B:E4'
            set wireless.default_radio0.key='ornorcleor'

            # Set hostname, timezone
            set system.@system[0].hostname='klipperwrt'
            set system.@system[0].description='OpenWRT host for Klipper'
            set system.@system[0].zonename='America/Vancouver'
            set system.@system[0].timezone='PST8PDT,M3.2.0,M11.1.0'

            # Disable password authentication on SSH
            # Not working right now for some reason?
            #set dropbear.main.PasswordAuth='off'
            #set dropbear.main.RootPasswordAuth='off'


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
