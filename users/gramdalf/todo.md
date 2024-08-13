- [ ] vscode customizations
- [ ] Add fonts declaratively
- [ ] Onlyoffice, libreoffice declarative config
- [ ] Libreoffice compat changes
- [ ] vscodium md smart formatting 
- [ ] Unit nvidia-powerd.service not found (enable in nix config?)
- [ ] gkr-pam: unable to locate daemon control file | Gnome keyring - pluggable auth module. Related to gparted?
- [ ] Certain apps not starting - gparted
- [ ] sap-server operation not permitted | driver initialization failed
- [ ] /etc/nixos/flake.nix
             If this file exists, then nixos-rebuild will use it as
             if the --flake option was given. This file may be a sym‐
             link to a flake.nix in an actual flake; thus /etc/nixos
             need not be a flake.
- [ ] Mouse
    - [ ] MB4,5 DEL
    - [ ] 
- [X] (Encryption?) slowing down r/w when under load (writing files etc)
        - Change io scheduler
        - Fix: https://discord.com/channels/568306982717751326/1178769551777878086
- [ ] strings
- [ ] ADB bug report: adb --help displays `install [-lrtsdg]` but does not explain `-s` or `-l`
- [ ] borgmatic?
- [ ] https://docs.waydro.id/faq/setting-up-waydroid-only-sessions
- https://github.com/drozdziak1/nixos-pikvm

- fonts.fontconfig.defaultFonts.monospace = ["JetbrainsMono"];

- system.etc.overlay.enable option was added. If enabled, /etc is mounted via an overlayfs instead of being created by a custom perl script.

systemd.oomd module behavior has changed:

    Raise ManagedOOMMemoryPressureLimit from 50% to 80%. This should make systemd-oomd kill things less often, and fix issues like this. Reference: commit.

    Remove swap policy. This helps prevent killing processes when user’s swap is small.

    Expand the memory pressure policy to system.slice, user-.slice, and all user-owned slices. Reference: commit.

    Rename systemd.oomd.enableUserServices to systemd.oomd.enableUserSlices.

systemd.sysusers.enable option was added. If enabled, users and groups are created with systemd-sysusers instead of with a custom perl script.


boot.loader.systemd-boot.xbootldrMountPoint is a new option for setting up a separate XBOOTLDR partition to store boot files. Useful on systems with a small EFI System partition that cannot be easily repartitioned.

garage has been updated to v1.x.x. Users should read the upstream release notes and follow the documentation when changing over their services.garage.package and performing this manual upgrade.

NixOS now installs a stub ELF loader that prints an informative error message when users attempt to run binaries not made for NixOS.

    This can be disabled through the environment.stub-ld.enable option.

    If you use programs.nix-ld.enable, no changes are needed. The stub will be disabled automatically.

On flake-based NixOS configurations using nixpkgs.lib.nixosSystem, NixOS will automatically set NIX_PATH and the system-wide flake registry (/etc/nix/registry.json) to point <nixpkgs> and the unqualified flake path nixpkgs to the version of nixpkgs used to build the system.

This makes nix run nixpkgs#hello and nix-build '<nixpkgs>' -A hello work out of the box with no added configuration, reusing dependencies already on the system.

This may be undesirable if Nix commands are not going to be run on the built system since it adds nixpkgs to the system closure. For such closure-size-constrained non-interactive systems, this setting should be disabled.

To disable it, set nixpkgs.flake.setNixPath and nixpkgs.flake.setFlakeRegistry to false.

It is now possible to have a completely perlless system (i.e. a system without perl). Previously, the NixOS activation depended on two perl scripts which can now be replaced via an opt-in mechanism. To make your system perlless, you can use the new perlless profile:

{ modulesPath, ... }: {
  imports = [ "${modulesPath}/profiles/perlless.nix" ];
}

- See if systemd can use commands to register with avahi for specific links 

(ZFS features)
https://www.medo64.com/2022/01/my-zfs-settings/


- https://wiki.archlinux.org/title/Dell_TB16#Disabling_PCIE_power_manage
- https://wiki.archlinux.org/title/Dell_TB16#Unbinding_and_Rebinding - fixes USB issues w/ tb16 dock and keyboard

- 3d accel: 
  - https://webgpu.github.io/webgpu-samples/?sample=rotatingCube
  - https://get.webgl.org/webgl2/
  - https://webglsamples.org/aquarium/aquarium.html

- Does systemd's sysusers conflict with kanidm
  - Without docker, they may no longer need to be under 65k etc.