{ pkgs }: with pkgs; [
  nix-index
  home-manager
  nil
  nvfetcher

  gcc
  git
  git-lfs
  ripgrep

  tailscale
  openvpn

  samba
  cifs-utils
  nfs-utils

  # unstable.emacs
  #
  # Probably this is being overwritten by home-manager.
  #
  # TODO: Resolve the disparity.
  emacs-git
  notmuch mu isync
  keychain ledger gnupg
  ledger2beancount beancount
  mailutils
  pandoc texlive.combined.scheme-full
  w3m lynx
  # sendmail

  cmake
  gnumake
  libtool
  pinentry-curses
  tmux
  screen
  sqlite

  docker-compose

  file
  lynx
  wget
  htop
  bind
  traceroute
  nmap
  wol
  iperf
  lsof
  pciutils # lspci
  usbutils # lsusb
  lm_sensors
  parallel
  mtr
  # tftp

  (python311.withPackages (pythonPackages: with pythonPackages; [
    pymupdf
    pip
    colorama
    fuzzywuzzy
    pypdf2
    pycryptodome
    pyacoustid
    beets
    clint
    # chromaprint
  ]))

  chromaprint
  ocrmypdf

  tigervnc

  # Not necessary
  apcupsd

  vim
]
