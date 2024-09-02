{ inputs, config, lib, pkgs, ... }:
{
  options = {
    my.flakeLocation = lib.mkOption {
      default = null;
      description = "Location of nixos flake for config";
      type = lib.types.nullOr lib.types.path;
    };

    my.nixosConfigLocation = lib.mkOption {
      # default = "/etc/nixos/";
      internal = true;
      description = "Location of nixos configuration";
      type = lib.types.path;
    };
  };
  config = {
    my.nixosConfigLocation =
      if (config.my.flakeLocation != null)
      then "${config.my.flakeLocation}/hosts/${config.networking.hostName}/configuration.nix"
      else lib.warn "Didn't set 'my.flakeLocation', NIX_PATH functionality will degrade a little"
        "${inputs.self}/hosts/${config.networking.hostName}/configuration.nix";
  };
}
