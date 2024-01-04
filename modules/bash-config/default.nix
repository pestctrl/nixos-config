{ config, pkgs, lib, ... }:
let
  cfg = config.my.bash-config;
in
{

  options.my.bash-config.enable = lib.mkEnableOption "Enable bash configuration file";

  config = lib.mkIf cfg.enable {
  };
}
