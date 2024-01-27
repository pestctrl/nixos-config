{ pkgs }: with pkgs; [
  nix-index
  home-manager

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
  lynx
  vlc
  mpv
  obs-studio
  gparted
  audacity

  ninja
  gdb
  lldb
  mold
  lld
  clang-tools_16 # clangd, clang-format
  llvmPackages_16.libllvm

  (python311.withPackages (pythonPackages: with pythonPackages; [
    pymupdf
    pip
    colorama
    fuzzywuzzy
    pypdf2
    pycryptodome
    pyacoustid
    beets
    # chromaprint
  ]))
  nodejs_21

  yt-dlp
  dconf

  tigervnc
  xorg.xinit
  sx

  wget
  lsof
  pciutils # lspci
  htop
  bind
  nmap
  lm_sensors

  beets
  chromaprint
  qdirstat
  signal-desktop
  parsec-bin
  discord
  telegram-desktop
  dunst
  shutter
  # unstable.rustdesk
  ocrmypdf
  mailutils
  # sendmail

  pcmanfm
  libsForQt5.dolphin
  libsForQt5.dolphin-plugins
  libsForQt5.ffmpegthumbs
  libsForQt5.kdegraphics-thumbnailers

  pavucontrol

  vim
]
