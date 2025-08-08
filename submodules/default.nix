{ inputs, config, pkgs, lib, ... }@args:
let
  beets-cfg = config.my.beets-config;
  tmux-cfg = config.my.tmux-config;
  work-bash-cfg = config.my.work-bash-config;
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
    my.work-bash-config.enable = lib.mkEnableOption "Enable work bash configurations";
  };

  config = {
    home.file = (mkIfFlakeLoc work-bash-cfg.enable
      "I won't symlink bashrc and bash_profile into place"
      {
        ".bashrc" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.my.flakeLocation}/submodules/work-bash-config/dot-bashrc.sh";
        };
        ".bash_profile" = {
          source = config.lib.file.mkOutOfStoreSymlink
            "${config.my.flakeLocation}/submodules/work-bash-config/dot-bash_profile.sh";
        };

      }
    );

    xdg = {
      configFile = {
        "beets/config.yaml" = (mkIfFlakeLoc beets-cfg.enable
          "I won't symlink beets' config.yaml into place"
          {
            source = config.lib.file.mkOutOfStoreSymlink
              "${flakeSubmodules}/beets-config/config.yaml";
            # Recursive only applies to directories. If false, do one
            # symlink (which is the directory). Otherwise, do every file
            # recursively
            #
            # recursive = true;
          });

        "tmux/tmux.conf" = (mkIfFlakeLoc tmux-cfg.enable
          "I won't symlink tmux's tmux.conf into place"
          {
            source = config.lib.file.mkOutOfStoreSymlink
              "${flakeSubmodules}/tmux-config/tmux.conf";
          });

        "wezterm/" = (mkIfFlakeLoc beets-cfg.enable
          "I won't symlink wezterm config folder into place"
          {
            source = config.lib.file.mkOutOfStoreSymlink
              "${config.my.flakeLocation}/submodules/wezterm-config/";
          });

        "bash/" = (mkIfFlakeLoc work-bash-cfg.enable
          "I won't symlink bash config folder into place"
          {
            source = config.lib.file.mkOutOfStoreSymlink
              "${config.my.flakeLocation}/submodules/work-bash-config/dot-config-bash/";
          });
      };

      dataFile = {
        "fonts/王漢宗中明體注音.ttf" = (mkIfFlakeLoc true
          "I won't symlink chinese fonts into place"
          {
            source = config.lib.file.mkOutOfStoreSymlink
              "${flakeSubmodules}/fonts/王漢宗中明體注音.ttf";
          });
      };
    };
  };
}
