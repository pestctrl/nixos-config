[[ "$TERM" = "dumb" ]] && return

alias ls='ls --color=auto'

export EDITOR="emacsclient"

if [[ "$INSIDE_EMACS" = 'vterm' ]]; then
   source ~/.config/bash-config/emacs.sh
fi