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
        layout = lib.mkForce "neo_dvorak,us";

        extraLayouts = {
          neo_dvorak = {
            description = "Dvorak with Neo2 Extensions";
            symbolsFile = ../res/xkb/symbols/neo_dvorak;
            languages = [ "eng" ];
          };
        };
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
