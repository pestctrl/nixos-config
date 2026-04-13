# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports = [
    ../../common/configuration.nix
    ../../common/user-facing.nix
    ../../common/development-machine.nix
    ../../common/moms-house
    ../../common/flake-location.nix
    ./hardware-configuration.nix
  ];

  my.flakeLocation = "/home/benson/nixos-config/";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  services.xserver.windowManager.i3.enable = true;

  # Make a VNC server available
  systemd.services.vncserver_emacs = (import ../../common/exprs/make-vncserver.nix pkgs "benson" ":1" "5901" "xstartup");
  systemd.services.vncserver_i3 = (import ../../common/exprs/make-vncserver.nix pkgs "benson" ":2" "5902" "i3");
  networking = {
    hostName = "Ythotha";
    interfaces = {
      eno2 = {
        wakeOnLan.enable = true;
      };
    };
    firewall = {
      # VNC Servers
      allowedTCPPorts = [ 5901 5902 ];
      # Wake-On-LAN
      allowedUDPPorts = [ 9 ];
    };
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.benson = {
    isNormalUser = true;
    description = "Benson Chu";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    cmatrix
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}
