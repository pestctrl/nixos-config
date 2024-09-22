{ inputs, config, pkgs, ... }:

{
  environment.variables = {
    # Valgrind like to use this instead of HOSTNAME
    HOST = config.networking.hostName;
    DIRENV_SKIP_TIMEOUT = "TRUE";
  };

  environment.systemPackages = with pkgs; [
    sbcl
    zstd.dev
    zstd.out

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

    # RE Tools
    radare2
    gcc-arm-embedded
    rizin
    cutter

    nodejs_22

    minikube
    kubectl
    talosctl
    k9s
    (wrapHelm kubernetes-helm {
      plugins = with pkgs.kubernetes-helmPlugins; [
        # helm-secrets
        helm-diff
        helm-s3
        helm-git
      ];
    })

    # mps.overrideAttrs (old: {
    #   pname = "mps";
    #   version = "1.118.0";

    #   src = fetchFromGitHub {
    #     owner = "Ravenbrook";
    #     repo = "mps";
    #     rev = "refs/tags/release-${version}";
    #     hash = "sha256-3ql3jWLccgnQHKf23B1en+nJ9rxqmHcWd7aBr93YER0=";
    #   };
    # })
  ];

  boot.kernel.sysctl."kernel.perf_event_paranoid" = 1;
}
