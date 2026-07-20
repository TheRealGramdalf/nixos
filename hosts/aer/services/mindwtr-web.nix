{ inputs, ...}: let
  cfg.domain = "mindwtr.aer.dedyn.io";
  port = 6940;
in {

  # Add a listen address for nginx
  services.nginx.virtualHosts."${cfg.domain}" = {

    root = inputs.self.outputs.packages.x86_64-linux.mindwtr-web;
    listen = [
    {
      addr = "127.0.0.1";
      inherit port;
    }
  ];
    index = "index.html";
    extraConfig = ''
      index index.html;
      add_header X-Content-Type-Options "nosniff" always;
      add_header X-Frame-Options "SAMEORIGIN" always;
    '';

    locations = {
    # Hashed build assets: cache forever, and a missing chunk must 404 so the
    # client can recover — never fall back to index.html (Safari then fails the
    # module import with "Importing a module script failed", and a service
    # worker could cache the HTML under the chunk URL).
    # Note: add_header in a location disables inheritance, so the security
    # headers are repeated here and below.
      "/assets/" = {
        extraConfig = ''
          add_header X-Content-Type-Options "nosniff" always;
          add_header X-Frame-Options "SAMEORIGIN" always;
          add_header Cache-Control "public, max-age=31536000, immutable" always;
        '';
        tryFiles = "$uri =404";
    };

    # Everything else (index.html, sw.js, manifest, icons) must revalidate so a
    # redeployed image is picked up instead of serving stale chunk references.
     "/" = {
      extraConfig = ''
        add_header X-Content-Type-Options "nosniff" always;
        add_header X-Frame-Options "SAMEORIGIN" always;
        add_header Cache-Control "no-cache" always;
      '';
        tryFiles = "$uri /index.html";
    };
    };

  };
  

  # Proxy nginx through traefik
  services.cone.extraFiles."mindwtr-web".settings = {
    http.routers."mindwtr-web" = {
      rule = "Host(`${cfg.virtualHost.domain}`)";
      service = "mindwtr-web";
      middlewares = "local-only";
    };
    http.services."mindwtr-web".loadbalancer.servers = [{url = "http://127.0.0.1:${toString port}";}];
  };
}
