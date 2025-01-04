{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (config.system) nixos;
  inherit (builtins) substring;
  inherit (inputs.nixpkgs) lastModifiedDate;
  dateFormatted = (
    "(" +
    # Year
    "${substring 0 4 lastModifiedDate}" +
    "/" +
    # Month
    "${substring 4 2 lastModifiedDate}" +
    "/" +
    # Day
    "${substring 6 2 lastModifiedDate}" +
    ", " +
    # Hour
    "${substring 8 2 lastModifiedDate}" +
    ":" +
    # Minute
    "${substring 10 2 lastModifiedDate}" +
    ")"
  );
in {

  boot.initrd.availableKernelModules = [ "uhci_hcd" "ehci_pci" "ata_piix" "ahci" "xhci_pci" "pata_jmicron" "firewire_ohci" "sd_mod" "sr_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.enableAllFirmware = true;

  imports = [ inputs.minegrub-theme.nixosModules.default];
  boot.loader.grub = {
    enable = true;
    # This device needs to be an entire disk, not a partition!
    device = "/dev/disk/by-id/wwn-0x50025385500dc182";
    minegrub-world-sel = {
      enable = true;
      customIcons = [{
        name = "nixos";
        lineTop = "${nixos.distroName} '${nixos.codeName}' ${dateFormatted}";
        # Adventure mode because it's immutable - you can't change it once it's built
        lineBottom = "Adventure Mode, No Cheats, Version: ${nixos.version}";
        # Icon: you can use an icon from the remote repo, or load from a local file
        imgName = "nixos";
        # customImg = builtins.path {
        #   path = ./nixos-logo.png;
        #   name = "nixos-img";
        # };
      }];
    };
  };

  fileSystems."/" = {
    device = "zroot/system-state";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "zroot/safe/home";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "zroot/ephemeral/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "zroot/safe/persist";
    fsType = "zfs";
    # Required for `hashedPasswordFile` to work properly
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/1B1B-D929";
    fsType = "vfat";
    neededForBoot = false;
  };

}
