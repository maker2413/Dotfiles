# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
PS1='[\u@\h \W]\$ '

export EDITOR="emacs -nw"

alias ll="ls -la"
alias emacs="emacs -nw"
alias gs="git status"

neofetch

# Pyenv Setup
export PATH="$HOME/.pyenv/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# Tfenv Setup
export PATH="$HOME/.tfenv/bin:$PATH"

# Rbenv Setup
export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init -)"
