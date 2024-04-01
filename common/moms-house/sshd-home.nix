{ config, pkgs, lib, options, ... }:

{
  services.openssh = {
    enable = true;
    ports = [ 2222 ];

    settings = {
      X11Forwarding = true;
      PasswordAuthentication = false;
      PermitRootLogin = "no";
      Macs = (options.services.openssh.settings.type.getSubOptions []).Macs.default ++ [
        "hmac-sha2-512"
        "hmac-sha2-256"
      ];
    };

    extraConfig = ''
      ChallengeResponseAuthentication no

      Match Address 10.0.0.0/8,!10.0.0.1
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
