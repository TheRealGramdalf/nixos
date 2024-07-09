{pkgs, ...}: {
  virtualisation.oci-containers.backend = "docker";
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_26;
    storageDriver = "zfs";
    liveRestore = true;
  };
  environment.systemPackages = [pkgs.docker-compose];
}
