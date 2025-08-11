{ inputs, config, pkgs, lib, ... }:
{
  fileSystems."/mnt/media" = {
    device = "//atlantis.local/media2";
    fsType = "cifs";
    options = [ "username=bchu" "password=Mathexpert457" "uid=1000" "x-systemd.automount" "noauto"];
  };

  fileSystems."/mnt/dump" = {
    device = "//atlantis.local/dump";
    fsType = "cifs";
    options = [ "username=bchu" "password=Mathexpert457" "uid=1000" "x-systemd.automount" "noauto"];
  };

  fileSystems."/mnt/puppet_recordings" = {
    device = "//atlantis.local/Puppet Recordings";
    fsType = "cifs";
    options = [ "username=bchu" "password=Mathexpert457" "uid=1000" "x-systemd.automount" "noauto"];
  };
}
