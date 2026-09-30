{ pkgs, lib, ... }: {
  virtualisation.libvirtd = {
    enable = true;
    # Don't autostart previously running VMs
    onBoot = "ignore";
    qemu = {
      vhostUserPackages = [pkgs.virtiofsd]; # Enables virtiofs shares
      #package = pkgs.qemu_kvm; # Look into, to save disk space?
    };
  };
  # Make libvirtd only socket activated
  systemd.services.libvirtd.wantedBy = lib.mkForce [];

  programs.virt-manager.enable = true;
  # Docker
  virtualisation.docker = {
    enable = true;
    enableOnBoot = false; # This increases startup time by 10 seconds on it's own. Not useful unless docker is always running.
  };
}