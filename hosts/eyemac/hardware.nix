_: {
  boot.initrd.availableKernelModules = ["xhci_pci" "ehci_pci" "ata_piix" "usbhid" "usb_storage" "sd_mod"];
  boot.loader.systemd-boot = {
    enable = true;
    editor = false;
  };
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
