# TODO
- [] Configuration test via https://github.com/traefik/traefik/issues/10804 (need to grab schema from traefik pkg, add schema output to traefik pkg)
CHANGELOG
- Removed usage of `with`, replacing it with `inherit` instead
- Do not always assume the systemd user must be created by NixOS
- Rename options to be more ergonomic and in line with the spirit of RFC 42
- (minimal downtime)
- Added `mkRenamedOptionModule`s where appropriate
- If created, the `traefik` users home directory is no longer created
- Increase UDP buffer sizes similar to caddy


? ~~reset gidnumber for unix accounts~~ (Groups not done yet, )
Figure out netbird multiple accounts - OIDC sync only possible with cloud version at the moment, manual invite may require mail server
Add modals to network shares on dashy
~~Add default perms for paperless-ngx~~
Copy ripped CDs to the server
Fix ARM movie/tv show encoding
Fix perms in SMB share folders + inheritance configs
Add welcome document explaining the server
Add idrac metrics with `node_exporter`
Investigate ebpf metrics for zpool latency (https://github.com/cloudflare/ebpf_exporter)

Breakpoint hook:
https://unix.stackexchange.com/a/728663
https://nixos.org/manual/nixos/stable/#sec-replace-modules

HA integrations to investigate:
- https://www.home-assistant.io/integrations/luci/
- https://www.home-assistant.io/integrations/ubus/
- https://www.home-assistant.io/integrations/opnsense/
- https://www.home-assistant.io/integrations/paperless_ngx/
- https://www.home-assistant.io/integrations/prometheus/

Add release note links
- Vaultwarden https://github.com/dani-garcia/vaultwarden/releases
- Paperless https://github.com/paperless-ngx/paperless-ngx/releases
- Netbird https://github.com/netbirdio/netbird/releases
- Kanidm https://github.com/kanidm/kanidm/releases
- NixOS https://nixos.org/manual/nixos/stable/release-notes
- Traefik https://doc.traefik.io/traefik/migrate/v3/
- Grafana https://grafana.com/docs/grafana/latest/whatsnew/
- Grafana Alloy https://grafana.com/docs/alloy/latest/release-notes/
- Grafana Loki https://grafana.com/docs/loki/latest/release-notes/ https://grafana.com/docs/loki/latest/setup/upgrade/


https://cr0x.net/en/zfs-snapshot-deletion-wont-delete/
https://gist.github.com/lbrame/f9034b1a9fe4fc2d2835c5542acb170a#user-content-quick-version-apply-the-mitigations-i-am-personally-using
https://svennd.be/understanding-zfs-checksum/


udev: use `systemd-analyze cat-config udev/rules.d`
046d:c537 - g602 receiver
framework-tool-tui
https://github.com/FrameworkComputer/linux-docs/blob/main/misc/audio-diagnostic/readme.md
https://github.com/FrameworkComputer/linux-docs/blob/main/Enhanced-WiFi-Analyzer/README.md
https://github.com/FrameworkComputer/linux-docs/blob/main/log-helper/readme.md
https://github.com/FrameworkComputer/linux-docs/blob/main/Tuned-PPD-Customizer-Script/readme.md
https://github.com/FrameworkComputer/linux-docs/blob/main/usb-events/readme.md


- `hardware.inputmodule`
- `hardware.ksm?`
- `hardware.sensor.hddtemp.enable ?`
- `kexec?`
- `boot.loader.refind`
- `boot.zfs.forceImportRoot - zfs_force option`
- `fonts.enableDefaultPackages?`
- `fonts.fontconfig.hinting.enable`
- `fonts.fontconfig.subpixel.lcdfilter`
- `networking.networkmanager.dns`
- `nix.daemonCPUSchedPolicy`
- `nix.daemonIOSchedClass`
- `nix.daemonIOSchedPriority`
- `nix.optimise.automatic # With fast-nix-gc/optimise`
- `powerManagement.cpuFreqGovernor`
- `powerManagement.powertop.enable`
- `programs.appimage.enable`
- `programs.appimage.binfmt`
- `programs.arp-scan.enable`
- `programs.bash.undistractMe.enable`
- `programs.bat.enable`
- `programs.bcc.enable`
- `programs.chromium.extensions`
- `programs.comma.enable`
- `programs.command-not-found.enable`
- `programs.gamemode.enable?`
- `programs.localsend.enable`
- `programs.neovim.defaultEditor`
- `programs.neovim.viAlias`
- `programs.neovim.vimAlias`
- `programs.obs-studio.enable`
- `programs.system-config-printer.enable`
- `programs.trippy.enable`
- `programs.udevil.enable`
- `programs.vivid.enable`