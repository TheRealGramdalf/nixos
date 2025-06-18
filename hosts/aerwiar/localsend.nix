{pkgs, ...}: {
  environment.systemPackages = [
    pkgs.localsend
  ];
  networking.firewall = {
    allowedUDPPorts = [53317];
    allowedTCPPorts = [53317];
  };
}
