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

  networking.hosts = {
    "192.168.1.78" = [ "BRWDCE994530FB4.local" "BRWDCE994530FB4" ];
  };
}
