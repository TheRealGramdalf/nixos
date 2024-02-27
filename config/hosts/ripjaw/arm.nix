{ config, lib, pkgs, ... }: {
  users.users."docker-ripjaw" = {
    description = "A.R.M. service account";
    home = "/persist/docker-ripjaw";
    uid = 911; # Lord of The Rings: The Twin Towers
    gid = 911;
  };
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers."ripjaw" = {
    autoStart = true;
    image = "automaticrippingmachine/automatic-ripping-machine:latest";
    ports = [ "8080:8080" ];
    volumes = [
      "/persist/docker-ripjaw/home:/home/arm"
      "/persist/docker-ripjaw/music:/home/arm/Music"
      "/persist/docker-ripjaw/logs:/home/arm/logs"
      "/persist/docker-ripjaw/media:/home/arm/media"
      "/persist/docker-ripjaw/config:/etc/arm/config"
    ];
    environment = {
      ARM_UID = "911";
      ARM_GID = "911";
    };
    extraOptions = [
      # Needed for ARM to work correctly - by default `CAP_SYS_ADMIN` is dropped
      # which blocks `mount()` calls within the container
      # This is needed in order to `mount /dev/sr0 /mnt/dev/sr0` for ripping, which may be avoidable by
      # handling mounts outside of the container, and having `/mnt/dev` bind mounted into the container.
      "--privileged"
      "--device=/dev/sr0:/dev/sr0"
      "--device=/dev/sr1:/dev/sr1"
    ];
  };
}