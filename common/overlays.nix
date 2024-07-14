inputs:
[
  (final: prev: {
    mps-debug = prev.mps.overrideAttrs (old: {
      pname = old.pname + "-debug";
      env.NIX_CFLAGS_COMPILE = old.env.NIX_CFLAGS_COMPILE + " -g -DCONFIG_VAR_COOL";
      dontStrip = true;
    });
  })
]
