{
  pkgs,
  lib,
  ...
}: {
  # Enable KDE
  services.desktopManager.plasma6 = {
    enable = true;
    enableQt5Integration = true;
  };
  qt.style = "breeze";
  services.displayManager.sddm = {
    # SDDM isn't enabled by the plasma6 module
    enable = true;
    # Enable Wayland in SDDM so the system doesn't need X11
    wayland.enable = true;
  };

  networking = {
    # Required for KDE to control wifi via GUI
    networkmanager.enable = true;
  };
  # Disable NM's wait-online service. This delays boot significantly
  systemd.services."NetworkManager-wait-online".enable = false;

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };
  services = {
    # Enable pulse/alsa emulation to try and get KDE's GUI working
    pipewire = {
      pulse.enable = true;
      alsa.enable = true;
    };
    # For piper
    ratbagd = {
      enable = true;
      package = pkgs.libratbag.overrideAttrs {
        src = pkgs.fetchFromGitHub {
          owner = "libratbag";
          repo = "libratbag";
          rev = "78d1124c3e7b992470017ab8a5b5af009745fe4f";
          hash = "sha256-+aCORAue2hs8DPcWPszzMwGC9SMfJ/A0zpn7tCwuD9Y=";
        };
      };
    };
    # Enable fingerprint reader
    fprintd.enable = true;
    # Printing, mDNS etc
    avahi = {
      enable = true;
      openFirewall = true;
      nssmdns4 = true;
      publish.enable = true;
    };
    # The actual printing control daemon
    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        hplip
        splix
        # For DCP-7065DN
        brlaser
      ];
    };
  };
}
