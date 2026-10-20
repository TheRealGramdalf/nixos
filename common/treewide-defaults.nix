{
  lib,
  config,
  pkgs,
  ...
}: {
  environment.sessionVariables = lib.optionalAttrs (config.services.netbird.enable) {
    NB_ADMIN_URL = "https://vpn.aer.dedyn.io";
    NB_MANAGEMENT_URL = "https://vpn.aer.dedyn.io";
  };

  environment.systemPackages = [pkgs.ghostty.terminfo];

  hardware.bluetooth.powerOnBoot = false;
  boot.tmp.cleanOnBoot = true;
  # Not needed (already default? might be stateversion)
  services.dbus.implementation = "broker";

  # The world must be oxidized
  security.sudo-rs.enable = true;

  
  # stolen from https://github.com/NixOS/nixpkgs/pull/576390/commits/16ac0cd8f4ebfa760f843348bb8c6d5037ea0333
  security.pki.caCertificateBlacklist = [
    # CVE-2026-111943
    "Comodo AAA Services root"
    # https://hg-edge.mozilla.org/projects/nss/rev/26d38a0c3fb81e7fb2acedbaf4c42dd21dce0517
    "emSign ECC Root CA - G3"
    # https://hg-edge.mozilla.org/projects/nss/rev/8159223c48ceeb1273a1915bca95a517294ab0e0
    "emSign Root CA - C1"
    "emSign ECC Root CA - C3"
  ];
}
