{ inputs, config, pkgs, lib, ... }:
let
  cfg = config.my.bash-config;

  # bash-drv = pkgs.stdenv.mkDerivation {
  #   name = "bash-config";
  #   src = inputs.bashcfg-input;
  #   dontBuild = true;
  #   installPhase = ''
  #     mkdir -p $out
  #     cp *.sh $out
  #   '';
  # };

  bash-drv = builtins.fetchGit {
    url = "https://github.com/pestctrl/bash-config";
    ref = "master";
  };
in
{
  options = {
    my.bash-config.enable = lib.mkEnableOption "Enable bash configuration file";
  };

  config = lib.mkIf cfg.enable {
    # Why can't I do the following?
    # home.file."${config.xdg.configHome}/bash-config/emacs.sh"
    # xdg.configFile."bash-config/emacs.sh".source = "${bash-drv}/emacs.sh";

    # home.file.".bashrc".source = "${bash-drv}/bashrc.sh";
    programs.bash.bashrcExtra = ''
      source ${bash-drv}/bashrc.sh
    '';
  };
}
