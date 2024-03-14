{ inputs, config, pkgs, ... }:

{
  nix.settings.experimental-features = "nix-command flakes";

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    # media-session.enable = true;
  };

  fonts = {
    packages = with pkgs; [
      roboto-mono
    ];
  };

  environment.systemPackages = with pkgs; [
    unstable.firefox
    unstable.google-chrome
    vlc
    mpv
    obs-studio
    gparted
    audacity

    qdirstat
    unstable.signal-desktop
    parsec-bin
    unstable.discord
    unstable.telegram-desktop
    dunst
    shutter
    # unstable.rustdesk

    pcmanfm
    libsForQt5.dolphin
    libsForQt5.dolphin-plugins
    libsForQt5.ffmpegthumbs
    libsForQt5.kdegraphics-thumbnailers

    pavucontrol

    xorg.xinit
    sx

    yt-dlp
    dconf
  ];
}
