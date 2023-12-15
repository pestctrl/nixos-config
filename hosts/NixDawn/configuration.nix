# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  commonPackages = import ../../common-packages.nix { inherit pkgs; };
in
{
  imports =
    [
      ../../common-configuration.nix
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  networking.hostName = "NixDawn"; # Define your hostname.
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;

  programs.nm-applet.enable = true;
  services.picom.enable = true;

  services.xserver.windowManager.exwm = {
    enable = true;
    enableDefaultConfig = false;
  };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "curses";
    enableSSHSupport = true;
  };

  services.syncthing = {
    enable = true;
    user = "benson";
    configDir = "/home/benson/.config/syncthing"; # Folder for Syncthing's settings and keys
    dataDir = "/home/benson/.config/syncthing/db"; # Folder for Syncthing's database
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.benson = {
    isNormalUser = true;
    description = "Benson Chu";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
      steam
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 2222 ];

    settings = {
      X11Forwarding = true;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };

    extraConfig = ''
      ChallengeResponseAuthentication no

      Match Address 192.168.0.0/16,!192.168.1.254
          X11UseLocalhost yes
          X11Forwarding yes
          PasswordAuthentication yes
          ChallengeResponseAuthentication yes
    '';
  };
  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
    pavucontrol
  ] ++ commonPackages;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
