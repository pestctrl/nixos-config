{ pkgs }: with pkgs; [
  nix-index
  home-manager
  nil

  gcc
  git
  git-lfs
  ripgrep

  tailscale
  openvpn

  samba
  nfs-utils

  unstable.emacs
  notmuch mu isync
  keychain ledger gnupg
  mailutils
  # sendmail

  cmake
  gnumake
  libtool
  pinentry-curses
  tmux
  sqlite

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

  (beets.override {
    pluginOverrides = {
      extrafiles = {
        enable = true;
        propagatedBuildInputs = [ beetsPackages.extrafiles ];
      };
    };
  })
  chromaprint
  ocrmypdf

  tigervnc

  # Not necessary
  apcupsd

  vim
]
