{inputs, ...}: {
  services.wazuh.agent = {
    enable = false;
    package = inputs.self.packages.x86_64-linux.wazuh-agent;
  };
}
