{config, lib, ...}: let
  cfg = config.services.postgresql;
  cfg2 = config.services.pgadmin;
  name = "db";
  authurl = "https://auth.aer.dedyn.io";
  clientid = "pgadmin-aer";
in {
  services.postgresql = {
    enable = true;
    dataDir = "/persist/services/db";
  };

  systemd.services."pgadmin".serviceConfig = {
    User = lib.mkForce "e3a51f72-3dfb-4742-b2b2-d7088e9be7be";
    Group = lib.mkForce "e3a51f72-3dfb-4742-b2b2-d7088e9be7be";
    EnvironmentFile = [
      "/persist/secrets/pgadmin/pgadmin.env"
    ];
  };
  services.pgadmin = {
    enable = true;
    initialEmail = "root@localhost";
    initialPasswordFile = "/persist/secrets/pgadmin/pwfile";
    settings = {
      DATA_DIR = "/persist/services/pgadmin";
      ##########################################################################
      # OAuth2 Configuration
      ##########################################################################

      # Multiple OAUTH2 providers can be added in the list like [{...},{...}]
      # All parameters are required

      OAUTH2_CONFIG = [
        {
          # The name of the of the oauth provider, ex: github, google
          OAUTH2_NAME = "kanidm";
          # The display name, ex: Google
          OAUTH2_DISPLAY_NAME = "Authstralia";
          # Oauth client id
          OAUTH2_CLIENT_ID = "${clientid}";
          # Oauth secret
          OAUTH2_CLIENT_SECRET = "os.getenv(\"OAUTH2_CLIENT_SECRET\")";
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
    #"postgres" = {
    #  http.routers.${name} = {
    #    rule = "Host(`${name}.aer.dedyn.io`)";
    #    service = ${name};
    #  };
    #  http.services.${name}.loadbalancer.servers = [
    #    {url = "127.0.0.1:${cfg.port}";}
    #  ];
    #};
    "postgres-ui" = {
      http.routers."${name}-ui" = {
        rule = "Host(`${name}.aer.dedyn.io`)";
        service = "${name}-ui";
        middlewares = ["local-only"];
      };
      http.services."${name}-ui".loadbalancer.servers = [
        {url = "http://127.0.0.1:${cfg2.port}";}
      ];
    };
  };
}
