{ inputs, config, lib, pkgs, ... }:
let
  system = "x86_64-linux";
in
{
  options = {
    my.flakeLocation = lib.mkOption {
      default = "/etc/nixos/";
      description = "Location of nixos flake for config";
      type = lib.types.path;
    };
  };
}
