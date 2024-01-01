{ pkgs }: with pkgs; [
  nix-index

  gcc
  git
  ripgrep

  unstable.emacs
  cmake
  gnumake
  libtool
  notmuch
  mu
  keychain
  ledger
  gnupg
  pinentry-curses
  isync
  tmux
  sqlite
  file

  sbcl

  firefox
  google-chrome
  vlc
  mpv
  obs-studio

  ninja
  gdb
  lldb
  mold
  lld

  python311
  python311Packages.pip
  nodejs_21

  yt-dlp
  dconf

  tigervnc
  xorg.xinit
  sx

  wget
  lsof
  htop

  beets
  qdirstat
  signal-desktop
  parsec-bin
  discord
  dunst
  shutter
  unstable.rustdesk

  pcmanfm
  libsForQt5.dolphin
  libsForQt5.dolphin-plugins
  libsForQt5.ffmpegthumbs
  libsForQt5.kdegraphics-thumbnailers

  vim
]
