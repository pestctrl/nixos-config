{ config, lib, pkgs, ... }:

{
  home.packages = [ pkgs.offlineimap ];

  systemd.user.services.offlineimap = {
    Unit = {
      Description = "OfflineIMAP - mail synchronization";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.offlineimap}/bin/offlineimap -u quiet";
      # Restart on failure with a delay
      Restart = "on-failure";
      RestartSec = 30;
      # Timeout for long syncs
      TimeoutStartSec = 300;
      # Environment (optional, e.g. for GPG/pass-based passwords)
      Environment = [
        "PATH=${lib.makeBinPath [ pkgs.gnupg pkgs.pass ]}"
      ];
      ExecStartPost = ''
        ${pkgs.myEmacs}/bin/emacsclient -e \
           "(mu4e-update-mail-and-index mu4e-index-update-in-background)"
      '';
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Timer to run periodically
  systemd.user.timers.offlineimap = {
    Unit = {
      Description = "Run OfflineIMAP periodically";
    };

    Timer = {
      OnBootSec = "2min";
      OnUnitActiveSec = "5min";
      Unit = "offlineimap.service";
    };

    Install = {
      WantedBy = [ "timers.target" ];
    };
  };
}
