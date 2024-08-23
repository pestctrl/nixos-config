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
    xkb = {
      layout = lib.mkForce "us,us";
      variant = lib.mkForce "dvorak,";
      options = "grp:win_space_toggle";
    };
  };

  # Configure console keymap
  console.keyMap = "dvorak";

  environment.systemPackages = with pkgs; [
    brightnessctl
    remmina
  ];
}
