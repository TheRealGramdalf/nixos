_: {
  users.groups."arm".gid = 911;
  users.users."arm" = {
    description = "A.R.M. service account";
    home = "/persist/arm";
    uid = 911; # Lord of The Rings: The Twin Towers
    group = "arm";
  };
  systemd.tmpfiles.rules = [
    "d /persist/arm 0700 arm arm - -"
    "d /persist/arm/config 0700 arm arm - -"
    "d /persist/arm/home 0700 arm arm - -"
  ];
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers."arm" = {
    autoStart = true;
    image = "automaticrippingmachine/automatic-ripping-machine:latest";
    ports = ["8080:8080"];
    volumes = [
      "/persist/arm/home:/home/arm"
      "/persist/arm/config:/etc/arm/config"
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
      # Pass the CD/Bluray/DVD drive to the container
      "--device=/dev/sr0:/dev/sr0"
    ];
  };
}
