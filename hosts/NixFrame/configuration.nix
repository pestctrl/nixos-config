{ config, pkgs, inputs, ... }:
{
  imports = [
    # ./home-git-repos.nix
    ../../common/configuration.nix
    ../../common/development-machine.nix
    ../../common/laptop-things.nix
    # Include the results of the hardware scan.
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "NixFrame"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  services.syncthing = {
    enable = true;
    user = "benson";
    configDir = "/home/benson/.config/syncthing"; # Folder for Syncthing's settings and keys
    dataDir = "/home/benson/.config/syncthing/db"; # Folder for Syncthing's database
  };

  services.fwupd.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];
    allowedUDPPortRanges = [
      { from = 1714; to = 1764; } # KDE Connect
    ];

    # Syncthing
    allowedTCPPorts = [ 22000 ];
    allowedUDPPorts = [ 22000 21027 ];
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

  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

}
