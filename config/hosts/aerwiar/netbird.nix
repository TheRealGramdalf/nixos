{pkgs, ...}: {
  services.netbird = {
    enable = true;
  };
  environment.systemPackages = [
    pkgs.netbird-ui
  ];
}