{ inputs, config, pkgs, lib, ... }:
let
  cfg = config.my.bash-config;

  bash-drv = pkgs.stdenv.mkDerivation {
    name = "bash-config";
    src = inputs.bashcfg-input;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out
      cp *.sh $out
    '';
  };
in
{
  options.my.bash-config.enable = lib.mkEnableOption "Enable bash configuration file";

  config = lib.mkIf cfg.enable {

    home-manager.users.benson = { ... }: {
      # Why can't I do the following?
      # home.file."${config.xdg.configHome}/bash-config/emacs.sh"
      xdg.configFile."bash-config/emacs.sh".source = "${bash-drv}/emacs.sh";

      home.file.".bashrc".source = "${bash-drv}/bashrc.sh";
    };
  };
}
