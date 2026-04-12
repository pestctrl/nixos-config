pkgs: user: port:
{
  enable = true;
  environment = {
    PATH = pkgs.lib.mkForce "/run/wrappers/bin:/home/${user}/.nix-profile/bin:/nix/profile/bin:/home/${user}/.local/state/nix/profile/bin:/etc/profiles/per-user/user/bin:/nix/var/nix/profiles/default/bin:/run/current-system/sw/bin";
  };
  unitConfig = {
    Description = "Remote desktop service (VNC)";
    After = "syslog.target network.target";
  };

  serviceConfig = {
    Type = "simple";
    User = "${user}";
    WorkingDirectory = "/home/${user}";
    Restart = "always";

    ExecStartPre = "${pkgs.bash}/bin/bash -c '${pkgs.tigervnc}/bin/vncserver -kill :1 > /dev/null 2>&1 || :'";
    ExecStart = "${pkgs.xorg.xinit}/bin/xinit /home/${user}/.vnc/xstartup -- ${pkgs.tigervnc}/bin/Xvnc :1 -rfbauth /home/${user}/.vnc/passwd -rfbport ${port}";
    ExecStop = "${pkgs.tigervnc}/bin/vncserver -kill :1";

  };

  wantedBy = ["multi-user.target"];
}
