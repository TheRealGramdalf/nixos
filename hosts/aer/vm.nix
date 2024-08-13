{lib, ...}: {
  # Fix ZFS devnodes in a VM
  boot.zfs.devNodes = lib.mkForce "/dev/disk/by-path";
  # Fix `nixos-rebuild *`
  networking.hostName = lib.mkForce "aer-test";
  # Add a password for logging in via the VM console
  users.users."root".password = "none";
  systemd.network.networks."20-ether" = {
    # Match all non-virtual (veth) ethernet connections
    matchConfig = {
      Type = "ether";
      Kind = "!*";
    };
    networkConfig = {
      DHCP = true;
    };
  };

  # Enable guest utils for qemu/spice
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # Made with `nixos-generate-config --show-hardware-config --root /mnt
  boot.initrd.availableKernelModules = ["ahci" "xhci_pci" "virtio_pci" "virtio_scsi" "sr_mod" "virtio_blk"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];
}
