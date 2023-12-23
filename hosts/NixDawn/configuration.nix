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
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
  networking.hostName = "NixDawn"; # Define your hostname.
  nix.settings.experimental-features = "nix-command flakes";

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
    nm-applet.enable = true;
    thunar.enable = true;

    gnupg.agent = {
      enable = true;
      pinentryFlavor = "gtk2";
      enableSSHSupport = true;
    };
  };

  services = {
    picom.enable = true;
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

    # Enable the OpenSSH daemon.
    openssh = {
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

      # Enable the KDE Plasma Desktop Environment.
      displayManager.sddm.enable = true;

      windowManager.exwm = {
        enable = true;
        enableDefaultConfig = false;
      };

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

  security.polkit.enable = true;
  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };

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
