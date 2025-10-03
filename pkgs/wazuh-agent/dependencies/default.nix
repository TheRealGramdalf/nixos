{
  dependencyVersion,
  fetchurl,
  lib,
  ...
}: let
  fetcher = (
    {
      name,
      sha256,
    }:
      fetchurl {
        url = "https://packages.wazuh.com/deps/${dependencyVersion}/libraries/sources/${name}.tar.gz";
        inherit sha256;
      }
  );
in
  lib.mapAttrsToList (
    name: dep: (fetcher {
      name = dep.name;
      sha256 = dep.sha256;
    })
  ) (import ./external_dependencies.nix)