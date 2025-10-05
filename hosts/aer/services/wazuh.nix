{inputs, lib, pkgs, ...}: {
  services.wazuh.agent = {
    enable = true;
    package = inputs.outputs.packages.x86_64-linux.wazuh-agent;
  };
}