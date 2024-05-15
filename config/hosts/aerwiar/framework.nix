{
  context,
  pkgs,
  ...
}: {
  environment.systemPackages = [context.inputmodule-pr.legacyPackages.${pkgs.system}.inputmodule-control];
  services.udev.packages = [context.inputmodule-pr.legacyPackages.${pkgs.system}.inputmodule-control];
}
