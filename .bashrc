# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export EDITOR="emacs -nw"

alias ll="ls -la"
alias emacs="emacs -nw"
alias gs="git status"
