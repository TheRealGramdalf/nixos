{pkgs, ...}: {
  virtualisation.oci-containers.backend = "docker";
  virtualisation.docker = {
    enable = true;
    liveRestore = true;
    package = pkgs.docker_26;
    storageDriver = "zfs";
    daemon.settings = {
      # ipv6 support isn't here yet
      ipv6 = false;
    };
  };
}
