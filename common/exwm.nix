{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    picom
    feh
    networkmanagerapplet
  ];

  services.xserver = {

    windowManager.session = [{
      name = "my-exwm";
      start = ''
        systemctl --user import-environment PATH DISPLAY XAUTHORITY DESKTOP_SESSION XDG_CONFIG_DIRS XDG_DATA_DIRS XDG_RUNTIME_DIR XDG_SESSION_ID DBUS_SESSION_BUS_ADDRESS || true
        dbus-update-activation-environment --systemd --all || true
        ${pkgs.myEmacs}/bin/emacs -l /home/benson/.emacs.d/init.el
      '';
    }];

    # gpg-agent = {
    #   enable = true;
    #   pinentryFlavor = "gtk2";
    # };
  };

  services.displayManager = {
    defaultSession = "none+my-exwm";
  };

  programs = {
    nm-applet.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-gtk2;
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
