{ config, pkgs, lib, ... }:
let
  cfg = config.my.bash-config;
in
{

  options.my.bash-config.enable = lib.mkEnableOption "Enable bash configuration file";

  config = lib.mkIf cfg.enable {

    home-manager.users.benson = { ... }: {
      # Why can't I do the following?
      # home.file."${config.xdg.configHome}/bash-config/emacs.sh"
      xdg.configFile."bash-config/emacs.sh".source = ./emacs.sh;

      home.file.".bashrc".source = ./bashrc.sh;
    };
  };
}
