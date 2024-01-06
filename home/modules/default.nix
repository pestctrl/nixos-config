# What's the difference between lib and pkg?
{ config, lib, ... }:

{
  # For each found file/folder, make it an absolute path by adding
  # "./." to the front.
  imports = map (x: ./. + "/${x}") (
    lib.attrNames (
      # Don't include default.nix, and files that don't end with
      # .nix. This means every subfolder MUST have a
      # default.nix.
      #
      # Perhaps, there's a way to do a tree traversal and grab ALL
      # .nix files?
      lib.filterAttrs
        (
          n: t: n != "default.nix" && (
            t == "directory" || lib.hasSuffix ".nix" n
          )
        )
        # Extract all files and folders in module directory. Returns
        # an attribute map with file name as key, and file type as
        # value.
        #
        # For some reason, the current directory is denoted as "./."
        # instead of "./". Why?
        (builtins.readDir ./.)
    )
  );
}
