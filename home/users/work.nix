{ inputs, config, pkgs, lib, ... }:

{
  imports = [
    ../modules
  ];

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  # home.username = "cvs";
  # home.homeDirectory = "/home/cvs";
  home.username = "a0487752";
  home.homeDirectory = "/home/a0487752";

  # my.bash-config.enable = true;

  nix = (lib.mkIf (!config.submoduleSupport.enable) {
    package = pkgs.nix;
    settings.experimental-features = "nix-command flakes";
    registry.nixpkgs.flake = inputs.nixpkgs;
  });

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    roboto-mono

    fastfetch

    rizin radare2 cutter
    ripgrep
    git

    cmatrix
    cmake gnumake libtool roswell sbcl
    dtc
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. If you don't want to manage your shell through Home
  # Manager then you have to manually source 'hm-session-vars.sh' located at
  # either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/benson/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "emacsclient -n";
  };

  # Let Home Manager install and manage itself.
  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      userName = "Benson Chu";
      userEmail = "b-chu1@ti.com";
      extraConfig = {
        core = {
          editor = "emacsclient";
        };
      };
    };

    emacs = {
      enable = true;
      package = pkgs.myEmacs;
    };

    # bash.enable = true; # see note on other shells below
  };

  services = {
    mbsync = {
      enable = true;
      frequency = "*:0/10";
      verbose = true;
    };
  };
}
