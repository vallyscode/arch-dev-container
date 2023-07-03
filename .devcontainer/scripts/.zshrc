## mac
# export LSCOLORS=exfxcxdxbxegedabagacad
export TERM="xterm-256color"
export HISTORY_IGNORE="(ls|cd|pwd|exit|history|cd -|cd ..)"
export EDITOR="vim"

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## user local bin folders
if [ -d "$HOME/.bin" ] ;
  then PATH="$HOME/.bin:$PATH"
fi

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi

## prompt customization
export PROMPT="%F{106}╭╴(%f%F{024}~%f%F{106})"$'\n'"╰╴%Bλ%b%f "
autoload -Uz promptinit
promptinit

autoload -Uz compinit
compinit

setopt histignorealldups sharehistory

HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history


alias grep='grep --color=auto'
alias ls='ls --color=auto'
alias pacman='sudo pacman --color=auto'
