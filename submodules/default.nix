{ inputs, config, pkgs, lib, ... }@args:
let
  beets-cfg = config.my.beets-config;
in
{
  options = {
    my.flakeLocation = lib.mkOption {
      default = null;
      description = "Location of nixos flake for config";
      type = lib.types.nullOr lib.types.path;
    };
    my.beets-config.enable = lib.mkEnableOption "Enable beets configuration file";
  };

  config = lib.mkIf beets-cfg.enable {
    # xdg.configFile."beets/config.yaml".source = ./beets-config/config.yaml;

    home = {
      file = {
        ".config/beets/config.yaml" = lib.mkIf (!(
          config.my.flakeLocation == null &&
          (lib.warn
            "Didn't set 'my.flakeLocation', I won't symlink beets' config.yaml into place"
            true)
        )) {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.my.flakeLocation}/submodules/beets-config/config.yaml";
          # Recursive only applies to directories. If false, do one
          # symlink (which is the directory). Otherwise, do every file
          # recursively
          #
          # recursive = true;
        };
      };
    };
  };
}
