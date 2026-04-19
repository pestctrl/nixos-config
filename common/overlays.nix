inputs: system:
[
  inputs.emacs-overlay.overlays.default

  (final: prev: {
    mps-debug = prev.mps.overrideAttrs (old: {
      pname = old.pname + "-debug";
      # Need to do this to patch dwarf information. For some reason,
      # stdenv copies the source into /build/source, and then builds
      # from there, leaving all the dwarf information hanging.
      env.NIX_CFLAGS_COMPILE = "-fdebug-prefix-map=/build/source=${old.src}";
      dontStrip = true;
    });
  })

  (final: prev: {
    mu = prev.mu.overrideAttrs (old: {
      patches = (old.patches or []) ++ [
        ./mu.patch
      ];
    });
  })

  (final: prev: {
    # final.emacs-git, final.emacs-unstable, or final.emacs-igc
    myEmacs =
      ((prev.emacsPackagesFor final.emacs-unstable)
        .emacsWithPackages (epkgs: with epkgs; [
          treesit-grammars.with-all-grammars
          (mu4e.override {
            mu = final.mu;
          })
        ]));
  })

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
]
