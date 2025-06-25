setxkbmap -I. neo_dvorak -option grp:ctrls_toggle -print | xkbcomp -I. - $DISPLAY
