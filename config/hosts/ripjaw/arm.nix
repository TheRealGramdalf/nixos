{ config, lib, pkgs, ... }: {
  virtualisation.oci-containers.backend = "docker";
  virtualisation.oci-containers.containers = {
    "ripjaw" = {
      autoStart = true;
      image = "automaticrippingmachine/automatic-ripping-machine:latest";
      ports = [ "8080:8080" ];
      volumes = [
        "/persist/ripjaw/home:/home/arm"
        "/persist/ripjaw/music:/home/arm/Music"
        "/persist/ripjaw/logs:/home/arm/logs"
        "/persist/ripjaw/media:/home/arm/media"
        "/persist/ripjaw/config:/etc/arm/config"
      ];
      #environment = {
      #  ARM_UID = "";
      #  ARM_GID = "";
      #};
      extraOptions = [
        # Needed for ARM to work correctly - by default `CAP_SYS_ADMIN` is dropped
        # which blocks `mount()` calls within the container
        # This is needed in order to `mount /dev/sr0 /mnt/dev/sr0` for ripping, which may be avoidable by
        # handling mounts outside of the container, and having `/mnt/dev` bind mounted into the container.
        "--priviledged"
        "--device /dev/sr0:/dev/sr0"
        "--device /dev/sr1:/dev/sr1"
        "--restart unless-stopped"
      ];
    };
  };
}