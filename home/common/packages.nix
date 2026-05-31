{ pkgs, config }: with pkgs; [
  direnv

  isync offlineimap

  gnumake libtool roswell sbcl

  rizin radare2 cutter

  rr
  clang-tools
  mold

  unstable.claude-code unstable.claude-agent-acp

  ripgrep git

  tmux cmatrix

  roboto-mono commit-mono

  fastfetch

  jira-cli-go
]
