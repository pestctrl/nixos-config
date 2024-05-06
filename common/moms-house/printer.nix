{ config, pkgs, ... }:

{
  services = {
    # Enable CUPS to print documents.
    printing = {
      enable = true;
      drivers = with pkgs; [
        cups-brother-mfcl2750dw
        brlaser
        brgenml1lpr
        brgenml1cupswrapper
      ];
    };

    # Enable auto-discovery of printers
    avahi = {
      enable = true;
      nssmdns = true;
      openFirewall = true;
    };
  };
}
