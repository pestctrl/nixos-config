{ inputs, config, pkgs, ... }:

{
  imports = [
    ./exwm.nix
  ];

  security.rtkit.enable = true;

  services = {
    # Enable sound with pipewire.
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

    pulseaudio.enable = false;

    # Enable the KDE Plasma Desktop Environment.
    desktopManager.plasma6.enable = true;

    xserver = {
      # Enable the X11 windowing system.
      enable = true;

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

    displayManager = {
      sddm.enable = true;
    };

    libinput = {
      enable = true;
      touchpad = {
        naturalScrolling = true;
      };
    };
  };

  fonts = {
    packages = with pkgs; [
      roboto-mono
      noto-fonts
      noto-fonts-extra
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      commit-mono
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
    gimp
    inkscape

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
    kdePackages.dolphin
    kdePackages.dolphin-plugins
    kdePackages.ffmpegthumbs
    kdePackages.kdegraphics-thumbnailers

    p7zip
    unzip

    qemu

    pavucontrol

    update.yt-dlp
    ffmpeg
    dconf

    xfce.xfce4-terminal

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

    seafile-client

    wezterm

    xorg.xkbcomp

    insomnia
  ];
}
