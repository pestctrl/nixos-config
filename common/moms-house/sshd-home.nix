{ config, pkgs, lib, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 2222 ];

    settings = {
      X11Forwarding = true;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
    };

    extraConfig = ''
      ChallengeResponseAuthentication no

      Match Address 192.168.1.0/24,!192.168.1.254
          X11UseLocalhost yes
          X11Forwarding yes
          PasswordAuthentication yes
          ChallengeResponseAuthentication yes
    '';
  };

  security.pam.services.sshd = {
    startSession = true;
    showMotd = true;
    unixAuth = lib.mkForce true;
  };
}
