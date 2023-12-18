{ inputs, ... }@flakeContext:
{ config, lib, pkgs, ... }: {
  config = {
    systemd = {
      services = {
        "getty@" = {
          wantedBy = [
            "multi-user.target"
          ];
        };
      };
    };
  };
}
