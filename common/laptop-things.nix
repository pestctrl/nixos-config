{ config, pkgs, ... }:

{
  services.logind = {
    extraConfig = "HandlePowerKey=suspend";
    lidSwitch = "suspend";
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
}
