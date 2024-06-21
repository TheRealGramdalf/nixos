{pkgs, ...}: {
  virtualisation.docker = {
    enable = true;
    package = pkgs.docker_26;
    storageDriver = "zfs";
    liveRestore = true;
  };
}