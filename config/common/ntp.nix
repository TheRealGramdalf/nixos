{ config, lib, pkgs, ... }: {
  services.chronyd = {
    directory = "/persist/chrony";
    enable = true;
  };
}