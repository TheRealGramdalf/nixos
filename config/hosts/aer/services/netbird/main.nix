_: {

  services.netbird.server = {
    # This top level switch enables some defaults based on top level options
    enable = true;
    domain = "vpn.aer.dedyn.io";
  };
  imports = [
    ./coturn.nix
    ./dashboard.nix
    ./management.nix
    ./signal.nix
  ];
}