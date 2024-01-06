{ config, pkgs, ... }:

let
  commonPackages = import ../../common/packages.nix { inherit pkgs; };
in
{
  imports =
    [
      # ./home-git-repos.nix
      ../../common/configuration.nix
      ../../common/laptop-things.nix
      ../../common/exwm.nix
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  networking.hostName = "NixFrame"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  home-manager.users.benson = { ... }: {
    home.stateVersion = "23.11";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.syncthing = {
    enable = true;
    user = "benson";
    configDir = "/home/benson/.config/syncthing"; # Folder for Syncthing's settings and keys
    dataDir = "/home/benson/.config/syncthing/db"; # Folder for Syncthing's database
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
  services.openssh.enable = true;

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
