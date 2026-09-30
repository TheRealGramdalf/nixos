{pkgs, ...}: {
  qt.style = "breeze";
  services = {
    # For piper
    ratbagd.enable = true;
  };
}
