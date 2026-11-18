{
  config,
  lib,
  pkgs,
  ...
}: {
  services.hardware.bolt.enable = true;

  hardware = {
    keyboard.qmk.enable = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    bluetooth.enable = true;
  };

  environment.systemPackages = [
    pkgs.qmk
  ];

  # 046d:c537 - g602 receiver
  # Disable wakeup from mouse
  # https://bbs.archlinux.org/viewtopic.php?id=305417
  services.udev.extraRules = ''
    ACTION=="add" SUBSYSTEM=="usb" ENV{DEVTYPE}=="usb_device" ATTRS{idVendor}=="046d" ATTRS{idProduct}=="c537" ATTR{power/wakeup}="disabled"
  '';

  boot = {
    kernelParams = [
      "amdgpu.freesync_video=1"
    ];
    initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usbhid"];
    kernelModules = ["kvm-amd"];
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
}
