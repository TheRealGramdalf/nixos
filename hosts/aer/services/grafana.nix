{
  tome,
  config,
  lib,
  ...
}: let
  graf = "sys";
  hl.authurl = "auth.aer.dedyn.io";
  srcfg = config.services.grafana.settings.server;
  cfg = config.services.grafana.settings;
  client_id = "grafana-aer_rs";
in {
  services.grafana = {
    enable = true;
    dataDir = "/persist/services/grafana";
    settings = {
      server = {
        domain = "${graf}.aer.dedyn.io";
        enable_gzip = true;
        enforce_domain = true;
        protocol = "http";
        # Do not include the port (irrelevant for reverse proxy)
        # and set the protocol to https (similar reason). Uses grafana variable expansion.
        root_url = "https://%(domain)s/";
      };
      security = {
        disable_initial_admin_creation = true;
        secret_key = "$__file{/persist/secrets/grafana/secret_key}";
      };
      database = {
        wal = true;
      };
      "auth.generic_oauth" = {
        enabled = true;
        # Pretty name
        name = "SSO";
        inherit client_id;
        client_secret = "$__file{/persist/secrets/grafana/client_secret}";
        api_url = "https://${hl.authurl}/oauth2/openid/${client_id}/userinfo";
        token_url = "https://${hl.authurl}/oauth2/token";
        auth_url = "https://${hl.authurl}/ui/oauth2";
        scopes = ["openid" "profile" "email" "groups"];
        login_attribute_path = "sub";
        name_attribute_path = "preferred_username";
        # If the user has the grafana admin group UUID in Kanidm, assign `GrafanaAdmin`
        # If not, and if they have the UUID of editor, assign `Editor`
        # If not, assign them the `Viewer` role
        role_attribute_path = "contains(groups[*], 'ac9f5859-92dd-4867-9c6b-97587ab2efa0') && 'GrafanaAdmin' || contains(groups[*], 'fc3b34fc-cda1-4601-b7f3-05e9a7e23c77') && 'Editor' || 'Viewer'";
        # Needed to grant full admin access, not just org admin access
        allow_assign_grafana_admin = true;
        use_pkce = true;
      };
    };
  };

  systemd.services = tome.mkUnixdService {
    nixosConfig = config;
    serviceName = "grafana";
    extraServiceConfig = {
      User = lib.mkForce "1137c4d1-6ea0-45dc-8612-bf46174d04d8";
      Group = lib.mkForce "1137c4d1-6ea0-45dc-8612-bf46174d04d8";
    };
  };
  # Disable the user created by the module
  # The group is still created
  users.users."grafana".enable = false;

  # Proxy grafana through traefik
  services.cone = {
    extraFiles = {
      "${graf}".settings = {
        http.routers."${graf}" = {
          rule = "Host(`${srcfg.domain}`)";
          service = "${graf}";
        };
        http.services."${graf}".loadbalancer.servers = [{url = "${srcfg.protocol}\://${srcfg.http_addr}\:${toString srcfg.http_port}";}];
      };
    };
  };
}
