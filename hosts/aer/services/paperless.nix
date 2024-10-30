{
  config,
  lib,
  ...
}: let
  cfg = config.services.paperless;
  name = "paperless";
  port = "28981";
  wantsKani = {
    unitConfig = {
      After = [
        config.systemd.services."kanidm-unixd".name
      ];
      Requires = [
        config.systemd.services."kanidm-unixd".name
      ];
    };
  };
in {
  systemd.services = {
    "paperless-scheduler" =
      {
        serviceConfig = {
          # Conflicts with the database connection
          PrivateNetwork = lib.mkForce false;
          EnvironmentFile = [
            "/persist/secrets/paperless/paperless.env"
          ];
        };
      }
      // wantsKani;
    "paperless-consumer" =
      {
        serviceConfig = {
          # Conflicts with the database connection
          PrivateNetwork = lib.mkForce false;
          EnvironmentFile = [
            "/persist/secrets/paperless/paperless.env"
          ];
        };
      }
      // wantsKani;
    "paperless-task-queue" =
      {
        serviceConfig = {
          EnvironmentFile = [
            "/persist/secrets/paperless/paperless.env"
          ];
        };
      }
      // wantsKani;
    "paperless-web" =
      {
        serviceConfig = {
          EnvironmentFile = [
            "/persist/secrets/paperless/paperless.env"
          ];
        };
      }
      // wantsKani;
  };
  services.paperless = {
    enable = true;
    mediaDir = "/tank/paperless";
    dataDir = "/persist/services/paperless/data";
    address = "127.0.0.1";
    user = "e89bf800-37ae-453b-8e9c-6b7f55dd82c6";
    settings = {
      # Postgres connection settings. Port is implicit, password is secret
      PAPERLESS_DBHOST = "localhost";
      PAPERLESS_DBNAME = "paperless-ngx-aer";
      PAPERLESS_DBUSER = "paperless-ngx-aer";

      PAPERLESS_ADMIN_USER = "root";
      # Password is also secret here

      PAPERLESS_DEBUG = false;
      PAPERLESS_FILENAME_FORMAT = "{owner_username}{created_year}/{created_month_name_short}/{title}/{doc_pk}";
      PAPERLESS_AUDIT_LOG_ENABLED = true; # Set up once things are running properly
      PAPERLESS_CONSUMER_SUBDIRS_AS_TAGS = true;
      PAPERLESS_EMPTY_TRASH_DIR = "${cfg.mediaDir}/media/.trash"; # Relative to `src/`, should be changed
      PAPERLESS_USE_X_FORWARD_HOST = true;
      PAPERLESS_USE_X_FORWARD_PORT = true;
      # OpenID Configuration:
      PAPERLESS_PROXY_SSL_HEADER = ["HTTP_X_FORWARDED_PROTO" "https"];
      PAPERLESS_APPS = "allauth.socialaccount.providers.openid_connect";
      ## This environment variable expects a string of JSON value
      #PAPERLESS_SOCIALACCOUNT_PROVIDERS = builtins.toJSON {
      #  openid_connect = {
      #    APPS = [
      #      {
      #        client_id = "paperless-ngx-aer_rs";
      #        name = "Authstralia";
      #        provider_id = "kanidm-aer";
      #        # This secret is substituted from the environment file
      #        secret = "$OAUTH2_SECRET";
      #        settings.server_url = "https://auth.aer.dedyn.io/oauth2/openid/paperless-ngx-aer_rs";
      #      }
      #    ];
      #    OAUTH_PKCE_ENABLED = "True";
      #  };
      #};
      PAPERLESS_REDIRECT_LOGIN_TO_SSO = true;
      # Use this variable to set a timezone for the Paperless Docker containers. If not specified, defaults to UTC.
      # Does this still happen when run with systemd?
      PAPERLESS_TIME_ZONE = "${config.time.timeZone}";

      # The default language to use for OCR. Set this to the language most of your
      # documents are written in.
      PAPERLESS_OCR_LANGUAGE = "eng";

      # This is required if you will be exposing Paperless-ngx on a public domain
      # (if doing so please consider security measures such as reverse proxy)
      PAPERLESS_URL = "https://${name}.aer.dedyn.io";
    };
  };

  # Override the module which incorrectly assumes user creation
  systemd.tmpfiles.settings."10-paperless" = lib.mkForce (
    let
      defaultRule = {
        inherit (cfg) user;
        group = cfg.user;
      };
    in {
      "${cfg.dataDir}".d = defaultRule;
      "${cfg.mediaDir}".d = defaultRule;
      "${cfg.consumptionDir}".d =
        if cfg.consumptionDirIsPublic
        then {mode = "777";}
        else defaultRule;
    }
  );

  services.cone.extraFiles."${name}".settings = {
    http.routers."${name}" = {
      service = "${name}";
      rule = "Host(`${name}.aer.dedyn.io`)";
    };
    http.services."${name}".loadBalancer.servers = [{url = "http://${cfg.address}\:${port}";}];
  };
}
