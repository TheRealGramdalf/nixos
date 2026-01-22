To explore the ouptut filesystem, use `nix shell nixpkgs#p7zip`, then `7z x` the **sysupgrade** image - then create an output directory (`mkdir output`) so that the folder `/root` doesn't conflict with the squashfs file (which is also named `root`), and `7z x root -ooutput`.

mDNS options:
https://github.com/openwrt/odhcpd/issues/206#issuecomment-2190746671