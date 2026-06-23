{
  config,
  lib,
  pkgs,
  ...
}: {
  services.hardware.bolt.enable = true;

  hardware = {
    enableAllFirmware = true;
    keyboard.qmk.enable = true;
  };

  environment.systemPackages = [
    pkgs.qmk
  ];

  specialisation."framework-16".configuration = {
    boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usbhid"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-amd"];
    boot.extraModulePackages = [];
  };

  specialisation."asus-l210k".configuration = {
    boot.initrd.availableKernelModules = ["xhci_pci" "uas" "sd_mod" "sdhci_pci"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = ["kvm-intel"];
    boot.extraModulePackages = [];
  };

  specialisation."msi-krait-gtx660".configuration = {
    boot.initrd.availableKernelModules = ["xhci_pci" "ahci" "usbhid" "uas" "sd_mod"];
    boot.initrd.kernelModules = [];
    boot.kernelModules = [];
    boot.extraModulePackages = [];

    # latest version that supports the gtx660
    hardware.nvidia.branch = "legacy_470";
    services.xserver.videoDrivers = [ "nvidia" ];
    # disable bluetooth, no card present on this machine
    hardware.bluetooth.enable = lib.mkForce false;
    # Legacy 470 drivers fail to compile with 7.X kernels
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages_6_18;
    hardware.nvidia.modesetting.enable = true;
  };

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
