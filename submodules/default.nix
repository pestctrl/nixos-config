{ inputs, config, pkgs, lib, ... }@args:
let
  beets-cfg = config.my.beets-config;
  tmux-cfg = config.my.tmux-config;
  mkIfFlakeLoc = condition: errorMsg: value:
    (lib.mkIf (condition &&
               !(config.my.flakeLocation == null &&
                 (lib.warn ("Didn't set 'my.flakeLocation', " + errorMsg) true)))
      value);
  flakeSubmodules = "${config.my.flakeLocation}/submodules";
in
{
  options = {
    my.flakeLocation = lib.mkOption {
      default = null;
      description = "Location of nixos flake for config";
      type = lib.types.nullOr lib.types.path;
    };
    my.beets-config.enable = lib.mkEnableOption "Enable beets configuration file";
    my.tmux-config.enable = lib.mkEnableOption "Enable tmux configuration file";
  };

  config = {
    # xdg.configFile."beets/config.yaml".source = ./beets-config/config.yaml;

    home = {
      file = {
        ".config/beets/config.yaml" = (mkIfFlakeLoc beets-cfg.enable
          "I won't symlink beets' config.yaml into place"
          {
            source = config.lib.file.mkOutOfStoreSymlink
              "${config.my.flakeLocation}/submodules/beets-config/config.yaml";
            # Recursive only applies to directories. If false, do one
            # symlink (which is the directory). Otherwise, do every file
            # recursively
            #
            # recursive = true;
          });

        ".config/tmux/tmux.conf" = (mkIfFlakeLoc tmux-cfg.enable
          "I won't symlink tmux's tmux.conf into place"
          {
            source = config.lib.file.mkOutOfStoreSymlink
              "${flakeSubmodules}/submodules/tmux-config/tmux.conf";
          });

        ".config/wezterm/" = (mkIfFlakeLoc beets-cfg.enable
          "I won't symlink wezterm config folder into place"
          {
            source = config.lib.file.mkOutOfStoreSymlink
              "${config.my.flakeLocation}/submodules/wezterm-config/";
          });
      };
    };
  };
}
