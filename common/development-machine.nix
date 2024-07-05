{ inputs, config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    sbcl
    racket

    ninja
    gdb
    lldb
    mold
    lld
    clang-tools_16 # clangd, clang-format
    llvmPackages_16.libllvm
    bear
    rr

    nodejs_21
  ];
}
