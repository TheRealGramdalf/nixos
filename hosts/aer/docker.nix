{pkgs, ...}: {
  virtualisation.oci-containers.backend = "docker";
  virtualisation.docker = {
    enable = true;
    liveRestore = true;
    package = pkgs.docker_26;
    storageDriver = "zfs";
    daemon.settings = {
      # Disable the default docker0 bridge
      bridge = "none";
      # ipv6 support isn't here yet
      ipv6 = false;
    };
  };
}
