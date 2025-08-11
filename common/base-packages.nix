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
  sshfs

  myEmacs

  notmuch mu isync
  keychain ledger gnupg
  ledger2beancount beancount fava
  hledger
  ledger-autosync
  mailutils
  pandoc texlive.combined.scheme-full
  texlivePackages.noto
  w3m lynx
  fzf
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

  zip

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

    lxml

    # RedditArchiver dependencies
    pyyaml
    anytree
    colored
    markdown2
    praw
    colored
    prawcore

    ofxclient
  ]))

  chromaprint
  ocrmypdf

  tigervnc

  # Not necessary
  apcupsd

  vim
]
