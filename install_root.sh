#!/bin/sh

set -e

# Source paths
YO=`pwd`
YO_BASH="$YO/bash"
YO_ZSH="$YO/zsh"

# Target paths
MY_HOME="$HOME"
if [ -z "$MY_HOME" ]; then
    MY_HOME="/root"
fi
MY_ZSH="$MY_HOME/.its-my-zsh"

# Install BASH aliases (in case ZSH isn't available)
ln -s "$YO_BASH/root_aliases" "$MY_HOME/.bash_aliases"
ln -s "$YO_BASH/bash_colours" "$MY_HOME/.bash_colours"
ln -s "$YO_BASH/bash_prompt" "$MY_HOME/.bash_prompt"

# Setup ZSH
echo "\033[0;32mCloning Oh My Zsh...\033[0m"
if [ ! -n "$ZSH" ]; then
  ZSH=~/.oh-my-zsh
fi
env git clone https://github.com/robbyrussell/oh-my-zsh.git "$ZSH"

echo "\033[1;35mConfiguring ZSH...Your password may be required to set zsh as default\033[0m"
chsh -s `which zsh`
ln -s "$YO_ZSH/zshrc" "$MY_HOME/.zshrc"
ln -s "$YO_ZSH" "$MY_ZSH"

echo 'Setup complete'
