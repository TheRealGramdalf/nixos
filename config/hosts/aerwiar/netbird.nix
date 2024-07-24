{pkgs, ...}: {
  services.netbird = {
    enable = true;
    tunnels = {
      "home".environment = {
        NB_ADMIN_URL="https://vpn.aer.dedyn.io";
        NB_MANAGEMENT_URL="https://vpn.aer.dedyn.io";
      };
    };
  };
  environment.systemPackages = [
    pkgs.netbird-ui
  ];
  environment.sessionVariables = {
    NB_ADMIN_URL="https://vpn.aer.dedyn.io";
    NB_MANAGEMENT_URL="https://vpn.aer.dedyn.io";
  };
}