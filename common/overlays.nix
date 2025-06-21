inputs:
[
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
      myEmacs =
        ((prev.emacsPackagesFor final.emacs-unstable)
          .emacsWithPackages (epkgs: with epkgs; [
            treesit-grammars.with-all-grammars
            mu4e
          ]));
    })
]
