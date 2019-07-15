#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

### VARIABLES ###

# Less Syntax Highlighting Variables

export LESS_TERMCAP_mb=$'\e[1;32m'
export LESS_TERMCAP_md=$'\e[1;32m'
export LESS_TERMCAP_me=$'\e[0m'
export LESS_TERMCAP_se=$'\e[0m'
export LESS_TERMCAP_so=$'\e[01;33m'
export LESS_TERMCAP_ue=$'\e[0m'
export LESS_TERMCAP_us=$'\e[1;4;31m'

# System Variables

export VISUAL="vim"
export EDITOR=vim
export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --border"

# Project Variables

export C=~/Projects/C
export CPP=~/Projects/CPP
export NAND=~/Software/nand2tetris

### FUNCTIONS ###

function git_merge {
  git checkout $1 && git pull &&  git pull origin $2 && git push && git checkout $2 && git pull origin $1 && git push
}

### ALIASES ###

# System Aliases

alias ls='ls --color=auto'
alias ll='ls -lsha --color=auto'
alias pacclean='sudo pacman -Rns $(pacman -Qtdq)'
alias sbr='source ~/.bashrc'
alias vbr='vim ~/.bashrc'

# Project Aliases

alias nand="cd $NAND"
alias ltb="cd ~/Software/linux-toolbox"

# NPM Aliases

alias npr='npm run'
alias npi='npm install'
alias npmpr='npm version patch && npm publish'

# Git Aliases

alias ga='git add'
alias gc='git commit -m'
alias gca='git commit --amend'
alias gs='git status'
alias gp='git push'
alias gr='git reset --hard'
alias gm='git_merge'

# End

neofetch
