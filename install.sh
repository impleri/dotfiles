#!/bin/sh

set -ea

# Source paths
export YO=`pwd`
export YO_BASH="$YO/bash"
export YO_ZSH="$YO/zsh"
export YO_GIT="$YO/git"
export YO_SSH="$YO/ssh"
export YO_SUBL="$YO/sublime-text"

# Target paths
MY_HOME="$HOME"
if [ -z "$MY_HOME" ]; then
    MY_HOME="~"
fi
export MY_BIN="$MY_HOME/.bin"
export MY_ZSH="$MY_HOME/.its-my-zsh"
export MY_SSH="$MY_HOME/.ssh"
export MY_SUBL="$MY_HOME/.config/sublime-text-3"
export MY_SUBL_INS="$MY_SUBL/Installed\ Packages"
export MY_SUBL_PKG="$MY_SUBL/Packages"

echo "\033[1;36mUserland Configuration and More...\033[0m"

# Set up SSH
echo "\033[0;33mSetting up SSH...\033[0m"
if [ ! -d "$MY_SSH" ]; then
    mkdir "$MY_SSH"
fi
mkdir "$MY_SSH/controlmasters"
ln -s "$YO_SSH/config" "$MY_SSH/config"

# Set up git
echo "\033[0;35mConfiguring git...\033[0m"
ln -s "$YO_GIT/gitignore" "$MY_HOME/.gitignore"
ln -s "$YO_GIT/gitconfig" "$MY_HOME/.gitconfig"

# Set up .bin
echo "\033[0;37mCreating local executables...\033[0m"
if [ ! -d "$MY_BIN" ]; then
    mkdir "$MY_BIN"
fi
if [ ! -d "$MY_HOME" ]; then
    mkdir "$MY_BIN"
fi

# Setup ZSH
echo "\033[1;35mConfiguring ZSH...\033[0m"

curl -L git.io/antigen > $MY_HOME/antigen.zsh
ln -s "$YO_ZSH/antigenrc" "$MY_HOME/.antigenrc"
ln -s "$YO_ZSH/zshrc" "$MY_HOME/.zshrc"
ln -s "$YO_ZSH" "$MY_ZSH"

ZSH_PATH=`which zsh`
if [ $SHELL != $ZSH_PATH ]; then
  echo "\033[1;35mYour password may be required to set zsh as default\033[0m"
  chsh -s $ZSH_PATH
fi

if [ -d "/Users" ]; then
    ./install_macos.sh
else
    ./install_linux.sh
fi

echo 'Setup complete'
