{pkgs, ...}: {
  services.netbird.enable = true;
  environment.systemPackages = [
    pkgs.netbird-ui
  ];
  environment.sessionVariables = {
    NB_ADMIN_URL="https://vpn.aer.dedyn.io";
    NB_MANAGEMENT_URL="https://vpn.aer.dedyn.io";
  };
}