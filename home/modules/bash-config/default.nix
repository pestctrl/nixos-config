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

  bash-drv = (import ../../../nvfetch/_sources/generated.nix {
    inherit (pkgs) fetchurl fetchgit fetchFromGitHub dockerTools;
  }).bash-config.src;
in
{
  options = {
    my.bash-config.enable = lib.mkEnableOption "Enable bash configuration file";
  };

  config = lib.mkIf cfg.enable {
    # Why can't I do the following?
    # home.file."${config.xdg.configHome}/bash-config/emacs.sh"
    xdg.configFile."bash-config/emacs.sh".source = "${bash-drv}/emacs.sh";

    # home.file.".bashrc".source = "${bash-drv}/bashrc.sh";
    programs.bash = {
      shellAliases = {
        enable_gdb = "sudo sysctl kernel.yama.ptrace_scope=0";
        disable_gdb = "sudo sysctl kernel.yama.ptrace_scope=3";
      };

      bashrcExtra = ''
        source ${bash-drv}/bashrc.sh

        # Need to figure out how to conditionally generate this
        if [[ -n $(which kubectl) ]]; then
          alias k=kubectl
          source <(kubectl completion bash | sed s/kubectl/k/g)
        fi
      '';
    };
  };
}
