{
  imports = [
    ./kanidm.nix
    ./traefik.nix
    ./vaultwarden.nix
    ./smb.nix
    ./jellyfin.nix
    ./postgres.nix
    ./netbird/main.nix
    #./cockpit.nix
    #./dashy.nix
    #./paperless.nix
  ];
}
