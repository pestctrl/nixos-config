{ config, pkgs, ... }:

let
  commonPackages = import ../../common-packages.nix { inherit pkgs; };
in
{
  imports =
    [
      # ./home-git-repos.nix
      ../../common-configuration.nix
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  networking.hostName = "NixFrame"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # VNC Server
  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "startplasma-x11";
  services.xrdp.openFirewall = true;

  services.syncthing = {
    enable = true;
    user = "benson";
    configDir = "/home/benson/.config/syncthing"; # Folder for Syncthing's settings and keys
    dataDir = "/home/benson/.config/syncthing/db"; # Folder for Syncthing's database
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth

  # Configure keymap in X11
  services.xserver = {
    layout = "us,us";
    xkbVariant = "dvorak,";
    xkbOptions = "grp:win_space_toggle";
  };

  # Configure console keymap
  console.keyMap = "dvorak";

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

  fonts = {
    packages = with pkgs; [
      roboto-mono
    ];
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [

  ] ++ commonPackages;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
