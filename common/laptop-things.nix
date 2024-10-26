{ config, pkgs, lib, ... }:

{
  imports = [
    ./user-facing.nix
  ];

  hardware.bluetooth.enable = true; # enables support for Bluetooth

  services = {
    logind = {
      extraConfig = "HandlePowerKey=suspend";
      lidSwitch = "suspend";
    };

    # Configure keymap in X11
    xserver = {
      xkb = {
        layout = lib.mkForce "us,us";
        variant = lib.mkForce "dvorak,";
        options = "grp:win_space_toggle";
      };
    };
  };

  # Configure console keymap
  console.keyMap = "dvorak";

  environment.systemPackages = with pkgs; [
    brightnessctl
    remmina
    acpi
  ];
}
