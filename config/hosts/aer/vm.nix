_: {
  # Add a password for logging in via the VM console
  users.users."root".password = "none";
  systemd.network.networks."20-ether" = {
    # Match all non-virtual (veth) ethernet connections
    matchConfig = {
      Type = "ether";
      Kind = "!*";
    };
    networkConfig = {
      DHCP = true;
    };
  };
  services.qemuGuest.enable = true;
}