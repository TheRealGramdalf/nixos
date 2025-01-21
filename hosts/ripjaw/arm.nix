{config, pkgs, ... }: let
  handbrake-nvpatched = pkgs.handbrake.overrideAttrs (oldAttrs: rec {
  configureFlags = oldAttrs.configureFlags ++ [ "--enable-nvenc" ];
  });
  ffmpeg-nvpatched = pkgs.ffmpeg_7-full.override {
    nv-codec-headers = pkgs.nv-codec-headers-11;
  };
in {
  users.groups."docker-ripjaw".gid = 911;
  users.users."docker-ripjaw" = {
    description = "A.R.M. service account";
    home = "/persist/docker-ripjaw";
    uid = 911; # Lord of The Rings: The Twin Towers
    group = "docker-ripjaw";
    extraGroups = [
      "video"
      "render"
    ];
  };
  environment.systemPackages = [
    handbrake-nvpatched
    ffmpeg-nvpatched
  ];
  hardware.nvidia-container-toolkit.enable = true;
  # Enable CDI in the docker daemon
  virtualisation.docker.daemon.settings.features.cdi = true;
  # Add nvidia to videoDrivers to load it, or the CDI spec won't be generated
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    # Open driver doesn't support kepler
    open = false;
    powerManagement = {
      enable = false;
      finegrained = false;
    };
    # Legacy 470 drivers are required for k2000
    package = config.boot.kernelPackages.nvidiaPackages.legacy_470;
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
      "${handbrake-nvpatched}:/handbrake-nvpatched:ro"
      "/nix/store:/nix/store:ro"
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
      # Pass the nvidia card via CDI
      "--device=nvidia.com/gpu=all"
      # Pass the CD/DVD/Bluray drives. `sr0` is the top (bluray), the rest are in descending order
      "--device=/dev/sr0"
      "--device=/dev/sr1"
      "--device=/dev/sr1"
    ];
  };
}
