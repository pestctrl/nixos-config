# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ inputs, config, pkgs, lib, ... }:
let
  system = "x86_64-linux";
in
{
  imports = [
    ../modules/default.nix
    ./flake-location.nix
  ];

  nixpkgs.overlays = [
    (final: prev: {
      unstable = import inputs.unstable {
        inherit system;
        config.allowUnfree = true;
      };
    })
    (final: prev: {
      update = import inputs.update {
        inherit system;
        config.allowUnfree = true;
      };
    })
    # https://discourse.nixos.org/t/dolphin-does-not-have-mime-associations/48985/14
    # https://github.com/rumboon/dolphin-overlay/blob/main/default.nix
    (final: prev: {
      kdePackages = prev.kdePackages.overrideScope (kfinal: kprev: {
        dolphin = kprev.dolphin.overrideAttrs (oldAttrs: {
          nativeBuildInputs = (oldAttrs.nativeBuildInputs or []) ++ [ prev.makeWrapper ];
          postInstall = (oldAttrs.postInstall or "") + ''
        wrapProgram $out/bin/dolphin \
            --set XDG_CONFIG_DIRS "${prev.libsForQt5.kservice}/etc/xdg:$XDG_CONFIG_DIRS" \
            --run "${kprev.kservice}/bin/kbuildsycoca6 --noincremental ${prev.libsForQt5.kservice}/etc/xdg/menus/applications.menu"
      '';
        });
      });
    })
  ] ++ import ./overlays.nix inputs ++ [
    inputs.emacs-overlay.overlays.default
  ];

  nix = {
    settings.experimental-features = "nix-command flakes";

    nixPath = [
      "/home/benson/.nix-defexpr/channels"
      "nixpkgs=${inputs.nixpkgs}"
      config.my.nixosConfigLocation
      "/nix/var/nix/profiles/per-user/root/channels"];

    # MY GOD, this is what is used for nix develop, nix run, etc.
    registry = {
      system = {
        from = {
          type = "indirect";
          id = "system";
        };
        flake = inputs.nixpkgs;
      };
    };
  };

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = let
    automatic = config.services.automatic-timezoned.enable;
  in
    lib.mkIf (!automatic) "America/Chicago";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  system.autoUpgrade = {
    enable = true;
    flake = "/home/benson/nixos-config";
    flags = [
      "--update-input"
      "unstable"
      "-L" # print build logs
    ];
    dates = "12:00";
    randomizedDelaySec = "45min";
  };

  environment.systemPackages = import ./base-packages.nix { inherit pkgs; };

  services.tailscale.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
