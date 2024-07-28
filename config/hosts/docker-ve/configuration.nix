{pkgs, ...}: {
  environment = {
    systemPackages = with pkgs; [
      vim
      git
      lsd
      docker-compose
      lazydocker
      dive
      tcpdump
      kanidm
      iperf3
      traceroute
      samba
    ];
  };
  # Docker daemon settings
  virtualisation.docker.daemon.settings = {
    bridge = "none";
    ipv6 = false;
    default-address-pools = [
      {
        base = "172.30.0.0/16";
        size = 24;
      }
      {
        base = "172.31.0.0/16";
        size = 24;
      }
    ];
  };
  virtualisation.docker = {
    package = pkgs.docker_25;
    enable = true;
    liveRestore = true;
    storageDriver = "overlay2";
  };
}
