{inputs, ...}: {
  environment.systemPackages = [
    inputs.self.packages.x86_64-linux.timekpr-webui
  ];
}