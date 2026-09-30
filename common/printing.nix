{pkgs, ...}: {
  services = {
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
