{ config, pkgs, ... }:

{
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = with pkgs; [ brlaser brgenml1lpr brgenml1cupswrapper ];
  };

  # Enable auto-discovery of printers
  services.avahi = {
    enable = true;
    nssmdns = true;
    openFirewall = true;
  };
}
