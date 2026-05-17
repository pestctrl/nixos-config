{ pkgs, config }: with pkgs; [
  direnv

  isync offlineimap

  gnumake libtool roswell sbcl

  rizin radare2 cutter

  rr
  clang-tools
  mold

  claude-code claude-code-acp

  ripgrep git

  tmux cmatrix

  roboto-mono commit-mono

  fastfetch

  jira-cli-go
]
