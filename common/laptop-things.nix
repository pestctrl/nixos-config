{ config, pkgs, lib, ... }:

{
  imports = [
    ./user-facing.nix
  ];

  hardware.bluetooth.enable = true; # enables support for Bluetooth

  services = {
    logind = {
      settings.Login = {
        HandlePowerKey="suspend";
        HandleLidSwitch="suspend";
      };
    };

    # Configure keymap in X11
    xserver.xkb = {
      layout = lib.mkForce "neo_dvorak,us";
      options = "grp:ctrls_toggle";
      extraLayouts = {
        neo_dvorak = {
          description = "Dvorak with Neo2 Extensions";
          symbolsFile = ../res/xkb/symbols/neo_dvorak;
          languages = [ "eng" ];
        };
      };
    };
  };

  networking.networkmanager.plugins = [pkgs.networkmanager-openvpn];

  # Configure console keymap
  console.keyMap = "dvorak";

  environment.systemPackages = with pkgs; [
    brightnessctl
    remmina
    acpi
  ];
}
