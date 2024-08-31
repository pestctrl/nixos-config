{ inputs, config, pkgs, lib, ... }:
let
  beets-cfg = config.my.beets-config;
in
{
  options = {
    my.beets-config.enable = lib.mkEnableOption "Enable beets configuration file";
  };

  config = lib.mkIf beets-cfg.enable {
    # xdg.configFile."beets/config.yaml".source = ./beets-config/config.yaml;


    home = {
      file = {
        ".config/beets/config.yaml" = {
          source = config.lib.file.mkOutOfStoreSymlink ./. + "submodules/beets-config/config.yaml";
          # recursive = true;
        };
      };
    };
  };
}
