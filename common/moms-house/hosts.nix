{ config, pkgs, ... }:

{
  networking.hosts = {
    "192.168.0.10" = [ "ProxFaith" ];
    "192.168.0.102" = [ "TrueFaith" ];
    "192.168.0.100" = [ "FedoraFaith" ];
  };
}
