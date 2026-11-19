# forge: Noah's headless build/homelab VM (guest config, one file).
#
# Size: 6 vCPU, 16 GiB RAM, 64 GiB virtio disk (set on the host side).
# Build the boot disk:  nix build .#forge-image   ->  result/nixos.qcow2
# The image is sparse (a few GiB on disk) and grows to 64 GiB.
# It boots with UEFI (OVMF); the root fs grows to fill the disk on first boot.
#
# First boot: the console shows a Tailscale login URL. Send it to Noah;
# once he approves it, he reaches the VM over his tailnet and takes it from there.
# Nothing listens on the LAN: SSH and T3 Code are tailnet-only.
{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  # Noah's public keys (not secrets).
  sshKeys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkhdWfoClZZU6IImO6f92Ayt7H63a5EZ/obLCstg+Sh noah@dell7506"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINAbdx9MTfeHCXU4cRJft6pwtSubhZEzSWw2RPqU9gFA here-nor-there"
  ];
in {
  imports = [
    "${modulesPath}/profiles/qemu-guest.nix"
    # qcow2 image, UEFI, ext4 root labelled "nixos", ESP labelled "ESP".
    "${modulesPath}/virtualisation/disk-image.nix"
  ];

  nixpkgs.hostPlatform = "x86_64-linux";
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "26.05";

  virtualisation.diskSize = 64 * 1024; # MiB
  image.baseName = lib.mkForce "nixos";
  boot.loader.efi.canTouchEfiVariables = false;
  boot.kernelParams = ["console=tty0" "console=ttyS0,115200"];

  services.qemuGuest.enable = true;
  zramSwap.enable = true;

  networking = {
    hostName = "forge";
    useNetworkd = true;
    useDHCP = false;
    firewall = {
      enable = true;
      allowedTCPPorts = lib.mkForce [];
      trustedInterfaces = [];
      # SSH only over Tailscale.
      interfaces.tailscale0.allowedTCPPorts = [22];
    };
  };
  systemd.network = {
    enable = true;
    networks."10-ether" = {
      matchConfig = {
        Type = "ether";
        Kind = "!*";
      };
      networkConfig.DHCP = true;
    };
  };
  services.resolved.enable = true;
  time.timeZone = "America/Vancouver";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- Tailscale -----------------------------------------------------------
  services.tailscale = {
    enable = true;
    openFirewall = true; # UDP 41641 for direct connections
  };
  # Print the login URL on the console until the node is logged in.
  systemd.services.tailscale-login = {
    description = "Show the Tailscale login URL on the console";
    after = ["tailscaled.service" "network-online.target"];
    wants = ["tailscaled.service" "network-online.target"];
    wantedBy = ["multi-user.target"];
    path = [pkgs.tailscale pkgs.jq];
    serviceConfig = {
      Type = "simple";
      StandardOutput = "journal+console";
      StandardError = "journal+console";
      Restart = "on-failure";
      RestartSec = 30;
    };
    script = ''
      state=$(tailscale status --json | jq -r .BackendState || true)
      if [ "$state" = "Running" ]; then exit 0; fi
      echo "forge: log in to Tailscale with the URL below"
      exec tailscale up --hostname=forge
    '';
  };

  # --- SSH -----------------------------------------------------------------
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  # --- Users ---------------------------------------------------------------
  users.mutableUsers = false;
  users.groups.noah.gid = 1001;
  users.users.noah = {
    isNormalUser = true;
    uid = 1001;
    group = "noah";
    extraGroups = ["wheel"];
    openssh.authorizedKeys.keys = sshKeys;
    linger = true; # keep user services (T3) running without a login
  };
  users.users.root.openssh.authorizedKeys.keys = sshKeys;
  # Key-only, tailnet-only SSH, so no sudo password.
  security.sudo.wheelNeedsPassword = false;

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
    trusted-users = ["root" "noah"];
  };
  nix.optimise.automatic = true;
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # --- Claude Code + T3 Code -----------------------------------------------
  # Native Claude Code (~/.local/bin/claude) self-updates and needs nix-ld.
  # T3's preview browser is a downloaded headless Chromium; these are its libs.
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc.lib
      glib
      nspr
      nss
      atk
      at-spi2-atk
      at-spi2-core
      dbus
      expat
      mesa
      libgbm
      alsa-lib
      libxkbcommon
      systemd
      cups
      pango
      cairo
      libdrm
      libx11
      libxcomposite
      libxdamage
      libxext
      libxfixes
      libxrandr
      libxcb
    ];
  };
  environment.localBinInPath = true;
  fonts.packages = with pkgs; [dejavu_fonts noto-fonts noto-fonts-color-emoji];

  # T3 Code backend on loopback, published to the tailnet only (not Funnel).
  systemd.user.services.t3code-backend = {
    description = "T3 Code backend (loopback; Tailscale Serve HTTPS :8443)";
    unitConfig.ConditionUser = "noah";
    restartIfChanged = false;
    wantedBy = ["default.target"];
    after = ["network-online.target"];
    path = with pkgs; [t3code tailscale git coreutils bash nodejs];
    serviceConfig = {
      ExecStart = "${lib.getExe' pkgs.t3code "t3"} serve --host 127.0.0.1 --port 3773 --no-browser";
      Restart = "on-failure";
      RestartSec = 8;
      WorkingDirectory = "/home/noah";
    };
  };
  systemd.services.t3-tailscale-serve = {
    description = "Tailscale HTTPS :8443 -> T3 Code 127.0.0.1:3773";
    after = ["tailscaled.service"];
    wants = ["tailscaled.service"];
    wantedBy = ["multi-user.target"];
    path = [pkgs.tailscale];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    script = ''
      if tailscale status >/dev/null 2>&1; then
        tailscale serve --bg --https=8443 http://127.0.0.1:3773 || true
      fi
    '';
  };

  programs.git = {
    enable = true;
    config.credential."https://github.com".helper = ["" "!${lib.getExe pkgs.gh} auth git-credential"];
  };

  environment.systemPackages = with pkgs; [
    t3code
    gh
    git
    neovim
    tmux
    python3
    nodejs
    sqlite
    jq
    fd
    ripgrep
    poppler-utils
    android-tools
    htop
  ];
}
