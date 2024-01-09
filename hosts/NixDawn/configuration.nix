# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  commonPackages = import ../../common/packages.nix { inherit pkgs; };
in
{
  imports =
    [
      ../../common/configuration.nix
      ../../common/lxd-setup.nix
      ../../common/moms-house
      ../../common/exwm.nix
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  networking.hostName = "NixDawn"; # Define your hostname.

  fileSystems."/home/benson/workspace" = {
    device = "/dev/disk/by-uuid/aa640eb6-0655-446a-8a12-5867eeef6638";
    fsType = "ext4";
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.benson = {
    isNormalUser = true;
    description = "Benson Chu";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      kate
      steam
      dolphin
      breeze-icons
    ];
  };

  programs = {
    evince.enable = true;
    thunar.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
  };

  services = {
    # Having this enabled makes title bars in kde plasma disappear by
    # default. Only fixed by reloading the theme in system-settings
    # appearance.
    #
    # picom.enable = true;
    pcscd.enable = true;
    tailscale.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;
    tumbler.enable = true;

    syncthing = {
      enable = true;
      user = "benson";
      configDir = "/home/benson/.config/syncthing"; # Folder for Syncthing's settings and keys
      dataDir = "/home/benson/.config/syncthing/db"; # Folder for Syncthing's database
    };

    xserver = {
      # Enable the X11 windowing system.
      enable = true;
      exportConfiguration = true;

      # Configure keymap in X11
      layout = "us";
      xkbVariant = "";

      libinput = {
        enable = true;
        touchpad = {
          naturalScrolling = true;
        };
      };

      displayManager = {
        defaultSession = "none+exwm";
        sddm.enable = true;
      };
      # Enable the KDE Plasma Desktop Environment.
      desktopManager.plasma5.enable = true;

      xrandrHeads = [
        { output = "HDMI-1"; primary = false; monitorConfig = "Option \"PreferredMode\" \"2560x2880\""; }
        { output = "DP-3"; primary = true; }
      ];

      deviceSection = ''
        Option "TearFree"
      '';
    };
  };

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "benson" ];

  environment.systemPackages = with pkgs; [
    pavucontrol
    unstable.rustdesk
  ] ++ commonPackages;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
