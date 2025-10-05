{inputs, ...}: {
  services.wazuh.agent = {
    enable = true;
    package = inputs.self.packages.x86_64-linux.wazuh-agent;
  };
}
