{ config, pkgs, lib, ... }:

{
  imports = [
    ./user-facing.nix
  ];

  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
    lidSwitch = "suspend";
  };

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  networking.wireless.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = lib.mkForce "us,us";
    xkbVariant = lib.mkForce "dvorak,";
    xkbOptions = "grp:win_space_toggle";
  };

  # Configure console keymap
  console.keyMap = "dvorak";

  environment.systemPackages = with pkgs; [
    brightnessctl
  ];
}
