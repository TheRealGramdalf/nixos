{
  config,
  pkgs,
  ...
}: let
  serviceDir = "/persist/services/wazuh";
  ossec = "${serviceDir}/manager/ossec";
  filebeat = "${serviceDir}/manager/filebeat";
in {
  virtualisation.oci-containers.containers = {
    "wazuh-manager" = {
      image = "wazuh/wazuh-manager:4.13.1";
      hostname = "wazuh.manager";
      restart = "always";
      #ports = [
      #  "1514:1514"
      #  "1515:1515"
      #  "514:514/udp"
      #  "55000:55000"
      #];
      environment = {
        INDEXER_URL = "https://wazuh.indexer:9200";
        INDEXER_USERNAME = "admin";
        INDEXER_PASSWORD = "SecretPassword";
        FILEBEAT_SSL_VERIFICATION_MODE = "full";
        SSL_CERTIFICATE_AUTHORITIES = "/etc/ssl/root-ca.pem";
        SSL_CERTIFICATE = "/etc/ssl/filebeat.pem";
        SSL_KEY = "/etc/ssl/filebeat.key";
        API_USERNAME = "wazuh-wui";
        API_PASSWORD = "MyS3cr37P450r.*-";
      };
      volumes = [
        "${ossec}/api/configuration:/var/ossec/api/configuration"
        "${ossec}/etc:/var/ossec/etc"
        "${ossec}/logs:/var/ossec/logs"
        "${ossec}/queue:/var/ossec/queue"
        "${ossec}/var/multigroups:/var/ossec/var/multigroups"
        "${ossec}/integrations:/var/ossec/integrations"
        "${ossec}/active-response/bin:/var/ossec/active-response/bin"
        "${ossec}/agentless:/var/ossec/agentless"
        "${ossec}/wodles:/var/ossec/wodles"
        "${filebeat}/etc:/etc/filebeat"
        "${filebeat}/var:/var/lib/filebeat"
        "./config/wazuh_indexer_ssl_certs/root-ca-manager.pem:/etc/ssl/root-ca.pem"
        "./config/wazuh_indexer_ssl_certs/wazuh.manager.pem:/etc/ssl/filebeat.pem"
        "./config/wazuh_indexer_ssl_certs/wazuh.manager-key.pem:/etc/ssl/filebeat.key"
        "./config/wazuh_cluster/wazuh_manager.conf:/wazuh-config-mount/etc/ossec.conf"
      ];
      #labels = {
      #  "traefik.enable" = "true";
      #  "traefik.http.services.${name}.loadbalancer.server.port" = "8686";
      #  "traefik.http.routers.${name}.service" = "${name}";
      #  "traefik.http.routers.${name}.middlewares" = "local-only@file";
      #  "hl.host" = "${name}";
      #};
      extraOptions = [
        "--ulimit memlock=-1:-1"
        "--ulimit nofile=655360:655360"
        "--dns=1.1.1.1"
        "--dns-search=."
      ];
    };

    "wazuh-indexer" = {
      image = "wazuh/wazuh-indexer:4.13.1";
      hostname = "wazuh.indexer";
      restart = "always";
      #ports = [
      #  "9200:9200"
      #];
      environment = {
        OPENSEARCH_JAVA_OPTS = "-Xms1g -Xmx1g";
      };
      volumes = [
        "${serviceDir}/indexer/var:/var/lib/wazuh-indexer"
        "./config/wazuh_indexer_ssl_certs/root-ca.pem:/usr/share/wazuh-indexer/certs/root-ca.pem"
        "./config/wazuh_indexer_ssl_certs/wazuh.indexer-key.pem:/usr/share/wazuh-indexer/certs/wazuh.indexer.key"
        "./config/wazuh_indexer_ssl_certs/wazuh.indexer.pem:/usr/share/wazuh-indexer/certs/wazuh.indexer.pem"
        "./config/wazuh_indexer_ssl_certs/admin.pem:/usr/share/wazuh-indexer/certs/admin.pem"
        "./config/wazuh_indexer_ssl_certs/admin-key.pem:/usr/share/wazuh-indexer/certs/admin-key.pem"
        "./config/wazuh_indexer/wazuh.indexer.yml:/usr/share/wazuh-indexer/opensearch.yml"
        "./config/wazuh_indexer/internal_users.yml:/usr/share/wazuh-indexer/opensearch-security/internal_users.yml"
      ];
      extraOptions = [
        "--ulimit memlock=-1:-1"
        "--ulimit nofile=655360:655360"
        "--dns=1.1.1.1"
        "--dns-search=."
      ];
    };
    "wazuh-dashboard" = {
      image = "wazuh/wazuh-dashboard:4.13.1";
      hostname = "wazuh.dashboard";
      restart = "always";
      #ports = [
      #  "443:5601"
      #];
      environment = {
        INDEXER_USERNAME = "admin";
        INDEXER_PASSWORD = "SecretPassword";
        WAZUH_API_URL = "https://wazuh.manager";
        DASHBOARD_USERNAME = "kibanaserver";
        DASHBOARD_PASSWORD = "kibanaserver";
        API_USERNAME = "wazuh-wui";
        API_PASSWORD = "MyS3cr37P450r.*-";
      };
      volumes = [
        "./config/wazuh_indexer_ssl_certs/wazuh.dashboard.pem:/usr/share/wazuh-dashboard/certs/wazuh-dashboard.pem"
        "./config/wazuh_indexer_ssl_certs/wazuh.dashboard-key.pem:/usr/share/wazuh-dashboard/certs/wazuh-dashboard-key.pem"
        "./config/wazuh_indexer_ssl_certs/root-ca.pem:/usr/share/wazuh-dashboard/certs/root-ca.pem"
        "./config/wazuh_dashboard/opensearch_dashboards.yml:/usr/share/wazuh-dashboard/config/opensearch_dashboards.yml"
        "./config/wazuh_dashboard/wazuh.yml:/usr/share/wazuh-dashboard/data/wazuh/config/wazuh.yml"
        "${serviceDir}/dashboard/config:/usr/share/wazuh-dashboard/data/wazuh/config"
        "${serviceDir}/dashboard/custom:/usr/share/wazuh-dashboard/plugins/wazuh/public/assets/custom"
      ];
      dependsOn = "wazuh-indexer";
      labels = let
        name = "wazuh-dashboard";
      in {
        "traefik.enable" = "true";
        "traefik.http.services.${name}.loadbalancer.server.port" = "443";
        "traefik.http.routers.${name}.service" = "${name}";
        "traefik.http.routers.${name}.middlewares" = "local-only@file";
        "hl.host" = "${name}";
      };
      extraOptions = [
        "--ulimit memlock=-1:-1"
        "--ulimit nofile=655360:655360"
        "--link wazuh.indexer:wazuh.indexer"
        "--link wazuh.manager:wazuh.manager"
        "--dns=1.1.1.1"
        "--dns-search=."
      ];
    };
  };
}
