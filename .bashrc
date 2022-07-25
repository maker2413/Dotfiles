#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# alias ls='ls --color=auto'
# PS1='[\u@\h \W]\$ '

alias ll="ls -la"

alias ga="git add"
alias gc="git commit"
alias gd="git diff"
alias gl="git pull"
alias gp="git push"
alias gr="git restore"
alias gs="git status"

alias ya="yadm add"
alias yc="yadm commit"
alias yd="yadm diff"
alias yl="yadm pull"
alias yp="yadm push"
alias yr="yadm restore"
alias ys="yadm status"
