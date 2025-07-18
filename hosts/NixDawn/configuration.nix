# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
{
  imports = [
    ../../common/configuration.nix
    ../../common/user-facing.nix
    ../../common/development-machine.nix
    ../../common/lxd-setup.nix
    ../../common/moms-house
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  my.flakeLocation = "/home/benson/nixos-config/";

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "NixDawn"; # Define your hostname.
  networking.hostId = "5640b87e";

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
      kate
      steam
      moonlight-qt
      dolphin
      breeze-icons
      xautolock
      unstable.mqtt-explorer
      musescore
      unstable.spotify
      pulseaudio
      immich-cli
    ];
  };

  programs = {
    evince.enable = true;
    thunar.enable = true;
    mtr.enable = true;
    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    };
    coolercontrol.enable = true;
  };

  services = {
    # Having this enabled makes title bars in kde plasma disappear by
    # default. Only fixed by reloading the theme in system-settings
    # appearance.
    #
    # picom.enable = true;
    pipewire.pulse.enable = true;
    pcscd.enable = true;
    tailscale.enable = true;
    gvfs.enable = true;
    udisks2.enable = true;
    devmon.enable = true;
    tumbler.enable = true;
    fwupd.enable = true;

    logind = {
      extraConfig = ''
        IdleAction=hybrid-sleep
        IdleActionSec=30min
      '';
    };

    apcupsd = {
      enable = true;

      configText = ''
        UPSTYPE usb
        NISIP 127.0.0.1
        BATTERYLEVEL 50
        MINUTES 5
        ANNOY 30
      '';
    };

    syncthing = {
      enable = true;
      user = "benson";
      configDir = "/home/benson/.config/syncthing"; # Folder for Syncthing's settings and keys
      dataDir = "/home/benson/.config/syncthing/db"; # Folder for Syncthing's database
    };

    xserver = {
      # Enable the X11 windowing system.
      videoDrivers = [ "amdgpu" ];

      exportConfiguration = true;

      xrandrHeads = [
        { output = "HDMI-1"; primary = false; monitorConfig = "Option \"PreferredMode\" \"2560x2880\""; }
        { output = "DP-3"; primary = true; }
      ];

      deviceSection = ''
        Option "TearFree"
      '';
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
    xdgOpenUsePortal = true;
  };

  virtualisation = {
    virtualbox.host.enable = true;

    docker.enable = true;
  };

  users.extraGroups.vboxusers.members = [ "benson" ];
  users.extraGroups.docker.members = [ "benson" ];

  environment.systemPackages = with pkgs; [
    pavucontrol
    # unstable.rustdesk
    tarsnap
    # (pkgs.callPackage /home/benson/workspace/peter-nixos/mfcl2690dw/default.nix { } )
    clasp
    leiningen
    supercollider-with-sc3-plugins
  ];

  hardware.gkraken.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];

    # Syncthing
    allowedTCPPorts = [
      # vlc audio streaming
      8888
      22000
    ];
    allowedUDPPorts = [ 22000 21027 ];
  };

  # Mount NFS shares
  boot.supportedFilesystems = [ "nfs" ];
  services.rpcbind.enable = true;

  networking.hosts = {
    "10.254.0.1" = ["test.pestctrl.io"];
  };

  systemd = {
    targets.machines.enable = true;

    nspawn."arch" = {
      enable = true;
      execConfig = {Boot = true;};

      filesConfig = {
        # Bind resolve.conf to get networking
        BindReadOnly = ["/etc/resolv.conf:/etc/resolv.conf"];
        # Bind any directories that you want to be shared
        # Bind = ["/home/benson/"];
        # BindUser = ["benson"];
      };
      networkConfig = {Private = false;};
    };

    services."systemd-nspawn@arch" = {
      enable = true;
      requiredBy = ["machines.target"];
      overrideStrategy = "asDropin";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}
