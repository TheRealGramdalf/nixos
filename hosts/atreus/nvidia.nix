{
  config,
  pkgs,
  ...
}: {
  services = {
    thermald.enable = true;
  };
  hardware.graphics = {
    extraPackages = with pkgs; [
      vulkan-loader
      vulkan-validation-layers
      vulkan-extension-layer
    ];
  };
}
