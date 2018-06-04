#!/bin/sh

# Install BASH aliases (in case ZSH isn't available)
echo "\033[0;33mSetting up BASH aliases...\033[0m"
ln -s "$YO_BASH/bash_aliases" "$MY_HOME/.bash_aliases"
ln -s "$YO_BASH/bash_completion" "$MY_HOME/.bash_completion"
ln -s "$YO_BASH/bash_colours" "$MY_HOME/.bash_colours"
ln -s "$YO_BASH/bash_prompt" "$MY_HOME/.bash_prompt"
. "$MY_HOME/.bash_aliases"

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

env zsh
