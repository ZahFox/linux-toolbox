
# Less Syntax Highlighting

[[ $- != *i* ]] && return

export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

alias ls='ls --color=auto'
alias ll='ls -lsha --color=auto'
alias pacclean='sudo pacman -Rns $(pacman -Qtdq)'

export VISUAL="vim"
export EDITOR=vim

setxkbmap -option caps:swapescape
neofetch
