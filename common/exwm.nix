{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    picom
    feh
    networkmanagerapplet
  ];

  services.xserver = {
    displayManager = {
      defaultSession = "none+my-exwm";
    };

    windowManager.session = [{
      name = "my-exwm";
      start = ''
        ${pkgs.emacs-unstable}/bin/emacs -l /home/benson/.emacs.d/init.el
      '';
    }];
  };

  programs = {
    nm-applet.enable = true;
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "gtk2";
      enableSSHSupport = true;
    };
  };

  security.polkit.enable = true;
  # systemd = {
  #   user.services.polkit-gnome-authentication-agent-1 = {
  #     description = "polkit-gnome-authentication-agent-1";
  #     wantedBy = [ "graphical-session.target" ];
  #     wants = [ "graphical-session.target" ];
  #     after = [ "graphical-session.target" ];
  #     serviceConfig = {
  #       Type = "simple";
  #       ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
  #       Restart = "on-failure";
  #       RestartSec = 1;
  #       TimeoutStopSec = 10;
  #     };
  #   };
  # };
}
