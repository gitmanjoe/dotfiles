# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/user/.zshrc'

alias vim="nvim"
alias cdeez="cd"
alias deetsmachine="sl"
alias vi="nvim"
alias v="nvim"
alias nano="nvim"
alias emacs="nvim"
alias code="nvim"
alias :q="exit"
alias parserofthinepenilearea="/usr/bin/emacs -nw"

autoload -Uz compinit
compinit
# End of lines added by compinstall
export PROMPT="%n@%m %~ %# "
