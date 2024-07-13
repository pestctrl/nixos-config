{ inputs, config, pkgs, ... }:

{
  environment.variables = {
    # Valgrind like to use this instead of HOSTNAME
    HOST = config.networking.hostName;
  };

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
    valgrind

    nodejs_21
  ];

  boot.kernel.sysctl."kernel.perf_event_paranoid" = 1;
}
