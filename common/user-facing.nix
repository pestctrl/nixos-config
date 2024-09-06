{ inputs, config, pkgs, ... }:

{
  imports = [
    ./exwm.nix
  ];

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services = {

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      # media-session.enable = true;
    };
  };

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;

    # Enable the KDE Plasma Desktop Environment.
    desktopManager.plasma5.enable = true;

    # Enable sddm and startx
    displayManager = {
      startx.enable = true;
    };

    # Configure keymap in X11
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  services.displayManager = {
    sddm.enable = true;
  };

  services.libinput = {
    enable = true;
    touchpad = {
      naturalScrolling = true;
    };
  };

  fonts = {
    packages = with pkgs; [
      roboto-mono
      noto-fonts
      noto-fonts-extra
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
  };

  environment.systemPackages = with pkgs; [
    update.firefox
    update.google-chrome
    bitwarden
    vlc
    mpv
    obs-studio
    gparted
    audacity
    libreoffice

    imagemagick

    qdirstat
    update.signal-desktop
    parsec-bin
    update.discord
    update.telegram-desktop
    dunst
    shutter
    # update.rustdesk

    docker

    pcmanfm
    libsForQt5.dolphin
    libsForQt5.dolphin-plugins
    libsForQt5.ffmpegthumbs
    libsForQt5.kdegraphics-thumbnailers

    qemu

    pavucontrol

    yt-dlp
    dconf

    # TODO: Re-enable extrafiles
    (unstable.beets# .override {
    #   pluginOverrides = {
    #     extrafiles = {
    #       enable = true;
    #       propagatedBuildInputs = [ beetsPackages.extrafiles ];
    #     };
    #   };
    # }
    )

    (gnuplot.override { withQt = true; })

    appflowy

    tageditor
    easytag
  ];
}
