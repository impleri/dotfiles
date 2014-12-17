#!/bin/sh

set -e

YO=`pwd`
YO_BASH="$YO/bash"
YO_ZSH="$YO/zsh"
YO_GIT="$YO/git"
YO_SSH="$YO/ssh"

# Install BASH aliases (in case ZSH isn't available)
ln -s $YO_BASH/bash_aliases ~/.bash_aliases
ln -s $YO_BASH/bash_completion ~/.bash_completion
ln -s $YO_BASH/bash_colours ~/.bash_colours
ln -s $YO_BASH/bash_prompt ~/.bash_prompt

# Install ZSH
chsh -s `which zsh`
ln -s $YO_ZSH/zshrc ~/.zshrc
ln -s $YO_ZSH ~/.its-my-zsh

# Set up .bin
if [-d ~/.bin]
    mkdir ~/.bin
fi
ln -s $YO/drush/backport ~/.bin/backport

# Set up git
ln -s $YO_GIT/gitignore ~/.gitignore
ln -s $YO_GIT/gitconfig ~/.gitconfig

# Set up SSH
if [-d ~/.ssh]
    mkdir ~/.ssh
fi
mkdir ~/.ssh/controlmasters
ln -s $YO_SSH/ssh_config ~/.ssh/ssh_config

# Set up Sublime Text
# @TODO

echo 'Done'

