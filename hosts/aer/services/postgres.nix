{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.postgresql;
  cfg2 = config.services.pogadmin;
  name = "db";
  authurl = "https://auth.aer.dedyn.io";
  clientid = "pgadmin-aer_rs";
in {
  systemd.services."postgresql" = {
    after = [
      config.systemd.services."kanidm-unixd".name
    ];
    requires = [
      config.systemd.services."kanidm-unixd".name
    ];
    serviceConfig = {
      User = lib.mkForce "95795a5c-d0e0-4621-9956-22d2bc4955c3";
      Group = lib.mkForce "95795a5c-d0e0-4621-9956-22d2bc4955c3";
    };
  };
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    dataDir = "/persist/services/postgres";
    initdbArgs = [
      "--username=postgres-aer@auth.aer.dedyn.io"
      "--debug"
    ];
    #identMap = ''
    #  # Let other names login as themselves
    #  superuser_map      /^(.*)$   \1
    #'';
    authentication = lib.mkForce ''
      # Trust the unix socket
      local all all trust

      # Paperless uses plain password authentication
      host  all all 127.0.0.1/32 scram-sha-256
      host  all all ::1/128      scram-sha-256
    '';
    initialScript = pkgs.writeText "init-sql-script" ''
      CREATE ROLE pgadmin WITH PASSWORD 'pgadmin' SUPERUSER CREATEROLE CREATEDB REPLICATION BYPASSRLS LOGIN;
      CREATE DATABASE pgadmin;
      GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO pgadmin;
      GRANT ALL PRIVILEGES ON DATABASE postgres TO pgadmin;
      GRANT ALL PRIVILEGES ON DATABASE pgadmin TO pgadmin;
    '';
  };

  systemd.services."pgadmin" = {
    after = [
      config.systemd.services."kanidm-unixd".name
    ];
    requires = [
      config.systemd.services."kanidm-unixd".name
    ];
    serviceConfig.EnvironmentFile = [
      "/persist/secrets/pgadmin/pgadmin.env"
    ];
  };
  services.pogadmin = {
    enable = true;
    user = "e3a51f72-3dfb-4742-b2b2-d7088e9be7be";
    group = "e3a51f72-3dfb-4742-b2b2-d7088e9be7be";
    initialEmail = "pgadmin-aer@auth.aer.dedyn.io";
    initialPasswordFile = "/persist/secrets/pgadmin/pwfile";
    extraConfig = ''
      import os
      CONFIG_DATABASE_URI = f"postgresql://pgadmin:{os.getenv('DATABASE_PASSWORD')}@localhost/pgadmin"
    '';
    settings = {
      DEBUG = true;
      DATA_DIR = "/persist/services/pgadmin";
      ##########################################################################
      # OAuth2 Configuration
      ##########################################################################

      # Multiple OAUTH2 providers can be added in the list like [{...},{...}]
      # All parameters are required

      # Use oauth2 as a login method
      AUTHENTICATION_SOURCES = ["oauth2" "internal"];

      OAUTH2_CONFIG = [
        {
          # The name of the of the oauth provider, ex: github, google
          OAUTH2_NAME = "kanidm";
          # The display name, ex: Google
          OAUTH2_DISPLAY_NAME = "Authstralia";
          # Oauth client id
          OAUTH2_CLIENT_ID = "${clientid}";
          # Oauth secret
          # ?
          OAUTH2_CLIENT_SECRET = "os.getenv('OAUTH2_CLIENT_SECRET')";
          # URL to generate a token;
          # Ex: https://github.com/login/oauth/access_token
          OAUTH2_TOKEN_URL = "${authurl}/oauth2/token";
          # URL is used for authentication;
          # Ex: https://github.com/login/oauth/authorize
          OAUTH2_AUTHORIZATION_URL = "${authurl}/oauth2/authorise";
          # server metadata url might be optional for your provider
          OAUTH2_SERVER_METADATA_URL = "${authurl}/oauth2/openid/${clientid}/";
          # Oauth base url, ex: https://api.github.com/
          OAUTH2_API_BASE_URL = "None";
          # Name of the Endpoint, ex: user
          OAUTH2_USERINFO_ENDPOINT = "None";
          # Oauth scope, ex: 'openid email profile'
          # Note that an 'email' claim is required in the resulting profile
          OAUTH2_SCOPE = "openid email profile";
          # The claim which is used for the username. If the value is empty the
          # email is used as username, but if a value is provided;
          # the claim has to exist.
          OAUTH2_USERNAME_CLAIM = "preferred_username";
          # Font-awesome icon, ex: fa-github
          OAUTH2_ICON = "fa-lock";
          # UI button colour, ex: #0000ff
          OAUTH2_BUTTON_COLOR = "None";
          # The additional claims to check on user ID Token or Userinfo response.
          # This is useful to provide additional authorization checks
          # before allowing access.
          # Example for GitLab: allowing all maintainers teams, and a specific
          # developers group to access pgadmin:
          # 'OAUTH2_ADDITIONAL_CLAIMS'= {
          #     'https://gitlab.org/claims/groups/maintainer'= [
          #           'kuberheads/applications';
          #           'kuberheads/dba';
          #           'kuberheads/support'
          #      ];
          #     'https://gitlab.org/claims/groups/developer'= [
          #           'kuberheads/applications/team01'
          #      ];
          # }
          OAUTH2_ADDITIONAL_CLAIMS = "None";
          # Set this variable to False to disable SSL certificate verification
          # for OAuth2 provider.
          # This may need to set False, in case of self-signed certificates.
          # Ref: https://github.com/psf/requests/issues/6071
          OAUTH2_SSL_CERT_VERIFICATION = true;
          # set this variable to invalidate the session of the oauth2 provider
          # Example for keycloak:
          # 'OAUTH2_LOGOUT_URL': 'https://example.com/realms/master/protocol/openid-connect/logout?post_logout_redirect_uri={redirect_uri}&id_token_hint={id_token}'
          OAUTH2_LOGOUT_URL = "None";
        }
      ];
    };
  };

  services.cone.extraFiles = {
    #"postgres".settings = {
    #  http.routers.${name} = {
    #    rule = "Host(`${name}.aer.dedyn.io`)";
    #    service = ${name};
    #  };
    #  http.services.${name}.loadbalancer.servers = [
    #    {url = "127.0.0.1:${cfg.port}";}
    #  ];
    #};
    "postgres-ui".settings = {
      http.routers."${name}-ui" = {
        rule = "Host(`${name}.aer.dedyn.io`)";
        service = "${name}-ui";
        middlewares = ["local-only"];
      };
      http.services."${name}-ui".loadbalancer.servers = [
        {url = "http://127.0.0.1:${toString cfg2.port}";}
      ];
    };
  };
}
