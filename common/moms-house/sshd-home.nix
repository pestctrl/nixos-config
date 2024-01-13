{ config, pkgs, lib, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 2222 ];

    settings = {
      X11Forwarding = true;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
        "hmac-sha2-512"
        "hmac-sha2-256"
      ];
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
