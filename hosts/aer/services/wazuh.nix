{inputs, lib, pkgs}: {
  services.wazuh.agent = {
    enable = true;
  };
}