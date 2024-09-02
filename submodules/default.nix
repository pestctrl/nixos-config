{ inputs, config, pkgs, lib, ... }@args:
let
  beets-cfg = config.my.beets-config;
in
{
  options = {
    my.flakeLocation = lib.mkOption {
      default = "/home/${config.home.username}/nixos-config";
      description = "Location of nixos flake for config";
      type = lib.types.path;
    };
    my.beets-config.enable = lib.mkEnableOption "Enable beets configuration file";
  };

  config = lib.mkIf beets-cfg.enable {
    # xdg.configFile."beets/config.yaml".source = ./beets-config/config.yaml;

    home = {
      file = {
        ".config/beets/config.yaml" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.my.flakeLocation}/submodules/beets-config/config.yaml";
          # recursive = true;
        };
      };
    };
  };
}
