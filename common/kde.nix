{
  imports = [
    ./printing.nix
  ];

  # Enable KDE
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };
  ##TODO check
  #qt.style = "breeze";
  services.displayManager.sddm = {
    # SDDM isn't enabled by the plasma6 module
    enable = true;
    # Enable Wayland in SDDM so the system doesn't need X11
    wayland.enable = true;
  };

  networking = {
    # Required for KDE to control wifi via GUI
    networkmanager = {
      enable = true;
      dns = "systemd-resolved";
    };
    search = ["local" "lan"];
  };
  # Disable NM's wait-online service. This delays boot significantly
  systemd.services."NetworkManager-wait-online".enable = false;

  services = {
    # DNS
    resolved = {
      enable = true;
      settings."Resolve" = {
        LLMNR = "false";
        FallbackDns = [
          "1.1.1.1"
          "1.0.0.1"
        ];
        # Enable resolution only, leave responding to avahi
        MulticastDNS = "resolve";
      };
    };
    # Enable pulse emulation for the KDE GUI
    pipewire = {
      pulse.enable = true;
      # Disable alsa to reduce the number of audio outputs
      alsa.enable = false;
    };
    # Printing, mDNS etc
    avahi = {
      enable = true;
      # Enable publishing
      settings.publish = {
        disable-publishing = false;
        publish-addresses = true;
      };
      nssmdns4 = false;
      nssmdns6 = false;
    };
  };
}
