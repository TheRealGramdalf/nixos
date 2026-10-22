{
  config,
  lib,
  pkgs,
  ...
}: {
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usbhid"];
  boot.kernelModules = ["kvm-amd"];

  boot.kernelPackages = lib.mkForce (pkgs.linuxKernel.packages.linux_7_2.extend (
    _final: prev: {
      ## Courtesy of @kubkon
      # nixpkgs now signs every kernel module with kmodigest and the modules
      # aggregator expects a `<module>.ko.cer` next to every `.ko`
      # (https://github.com/NixOS/nixpkgs/issues/575192). framework-laptop-kmod
      # (pulled in by nixos-hardware's framework module) installs the `.ko` by
      # hand and so never produces one. This replicates the upstream fix,
      # https://github.com/NixOS/nixpkgs/pull/575818, which has not reached
      # nixos-unstable yet. Remove once it has.
      framework-laptop-kmod = prev.framework-laptop-kmod.overrideAttrs (old: {
        makeFlags = old.makeFlags ++ [
          "INSTALL_MOD_PATH=${placeholder "out"}"
          "INSTALL_MOD_DIR=extra"
          "DEPMOD=true"
        ];
        installPhase = null;
        installTargets = [ "modules_install" ];
      });
    }
  ));

  hardware = {
    enableAllFirmware = true;
    bluetooth.enable = true;
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  boot.zfs = {
    #STATEVERSION
    forceImportRoot = false;
    devNodes = "/dev/disk/by-partlabel";
  };

  fileSystems."/" = {
    device = "atreus-zroot/system-state";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "atreus-zroot/safe/home";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "atreus-zroot/ephemeral/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "atreus-zroot/safe/persist";
    fsType = "zfs";
    # Required for `hashedPasswordFile` to work properly
    neededForBoot = true;
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-partlabel/atreus-zboot";
    fsType = "vfat";
    options = ["fmask=0022" "dmask=0022"];
    neededForBoot = false;
  };
}
