_: {
  users.groups."docker-ripjaw".gid = 911;
  users.users."docker-ripjaw" = {
    description = "A.R.M. service account";
    home = "/persist/docker-ripjaw";
    uid = 911; # Lord of The Rings: The Twin Towers
    group = "docker-ripjaw";
  };
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers."ripjaw" = {
    autoStart = true;
    image = "automaticrippingmachine/automatic-ripping-machine:2.10.3";
    ports = ["8080:8080"];
    volumes = [
      "/persist/docker-ripjaw/home:/home/arm"
      "/persist/docker-ripjaw/config:/etc/arm/config"
      "/twotowers/arm/rips:/rips"
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
      "--device=/dev/sr1:/dev/sr2"
    ];
  };
}
