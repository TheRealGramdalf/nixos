{
  config,
  lib,
  ...
}: {
  services.hardware.bolt.enable = true;

  hardware.enableAllFirmware = true;

  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usbhid"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  hardware = {
    brillo.enable = true;
    bluetooth = {
      enable = true;
      powerOnBoot = false;
    };
  };

  fileSystems."/" = {
    device = "aerwiar-zpool/system-state";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "aerwiar-zpool/ephemeral/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "aerwiar-zpool/safe/persist";
    fsType = "zfs";
    # Required for `hashedPasswordFile` to work properly
    neededForBoot = true;
  };

  fileSystems."/home/gramdalf" = {
    device = "aerwiar-zpool/safe/home/gramdalf";
    fsType = "zfs";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/aerwiar-zboot";
    fsType = "vfat";
    neededForBoot = false;
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
