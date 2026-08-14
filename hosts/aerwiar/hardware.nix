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

  specialisation."kde-patched" = {
    environment.etc."specialisation".text = "kde-patched";

    nixpkgs.overlays = [
      (final: prev: {
        kdePackages = prev.kdePackages.overrideScope (
          kdeFinal: kdePrev: {
            # https://old.reddit.com/r/NixOS/comments/1pdtc3v/kde_plasma_is_slow_compared_to_any_other_distro/
            # https://github.com/NixOS/nixpkgs/issues/126590#issuecomment-3194531220
            plasma-workspace = let
              # the package we want to override
              basePkg = kdePrev.plasma-workspace;
              # a helper package that merges all the XDG_DATA_DIRS into a single directory
              xdgdataPkg = final.stdenv.mkDerivation {
                name = "${basePkg.name}-xdgdata";
                buildInputs = [basePkg];
                dontUnpack = true;
                dontFixup = true;
                dontWrapQtApps = true;
                installPhase = ''
                  mkdir -p $out/share
                  ( IFS=:
                    for DIR in $XDG_DATA_DIRS; do
                      if [[ -d "$DIR" ]]; then
                        ${prev.lib.getExe prev.lndir} -silent "$DIR" $out
                      fi
                    done
                  )
                '';
              };
              # undo the XDG_DATA_DIRS injection that is usually done in the qt wrapper
              # script and instead inject the path of the above helper package
              derivedPkg = basePkg.overrideAttrs {
                preFixup = ''
                  for index in "''${!qtWrapperArgs[@]}"; do
                    if [[ ''${qtWrapperArgs[$((index+0))]} == "--prefix" ]] && [[ ''${qtWrapperArgs[$((index+1))]} == "XDG_DATA_DIRS" ]]; then
                      unset -v "qtWrapperArgs[$((index+0))]"
                      unset -v "qtWrapperArgs[$((index+1))]"
                      unset -v "qtWrapperArgs[$((index+2))]"
                      unset -v "qtWrapperArgs[$((index+3))]"
                    fi
                  done
                  qtWrapperArgs=("''${qtWrapperArgs[@]}")
                  qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "${xdgdataPkg}/share")
                  qtWrapperArgs+=(--prefix XDG_DATA_DIRS : "$out/share")
                '';
              };
            in
              derivedPkg;
          }
        );
      })
    ];
  };
  boot = {
    kernelParams = [
      "amdgpu.freesync_video=1"
    ];
    initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usbhid"];
    kernelModules = ["kvm-amd"];
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
