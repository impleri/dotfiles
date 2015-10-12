#!/bin/sh

set -e

# Source paths
YO=`pwd`
YO_BASH="$YO/bash"
YO_ZSH="$YO/zsh"
YO_GIT="$YO/git"
YO_SSH="$YO/ssh"
YO_SUBL="$YO/sublime-text"

# Target paths
MY_HOME="$HOME"
if [ -z "$MY_HOME" ]; then
    MY_HOME="~"
fi
MY_BIN="$MY_HOME/.bin"
MY_ZSH="$MY_HOME/.its-my-zsh"
MY_NODE="$MY_HOME/.nodejs"
MY_SSH="$MY_HOME/.ssh"
MY_SUBL="$MY_HOME/.config/sublime-text-3"
MY_SUBL_INS="$MY_SUBL/Installed\ Packages"
MY_SUBL_PKG="$MY_SUBL/Packages"
MY_HOMESTEAD="$MY_HOME/.homestead"

# Other variables
HOMESTEAD_REPO="c4:web/homestead.git"

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

# Set up .bin
echo "\033[0;37mCreating local executables...\033[0m"
if [ ! -d "$MY_BIN" ]; then
    mkdir "$MY_BIN"
fi
ln -s "$YO/drush/backport" "$MY_BIN/backport"
ln -s "$YO/laravel/update" "$MY_BIN/update"

# Set up composer
echo "\033[0;32mGetting composer and global PHP packages...\033[0m"
curl -sS https://getcomposer.org/installer | php
mv composer.phar "$MY_BIN"
composer global config repositories.c4homestead vcs git@git.c4tech.com:web/homestead.git
composer global require phpunit/phpunit
composer global require squizlabs/php_codesniffer
composer global require fabpot/php-cs-fixer
composer global require phpmd/phpmd
composer global require drush/drush
composer global require laravel/homestead

# Set up node
./update-node.sh

# Set up Sublime Text
echo "\033[0;35mConfiguring Sublime Text...\033[0m"
if [ ! -d "$MY_SUBL" ]; then
    mkdir -p "$MY_SUBL_PKG"
    mkdir -p "$MY_SUBL_PKG/User"
fi

wget "https://packagecontrol.io/Package%20Control.sublime-package" -O "$MY_SUBL_INS/Package\ Control.sublime-package"
wget "http://colorsublime.com/theme/download/27550" -O "$MY_SUBL_INS/Colorsublime/Vibrant-Ink.tmTheme"
ln -s "$YO_SUBL/*.sublime-*" "$MY_SUBL_PKG/User/"

# Set up Homestead
echo "\033[1;32mInstalling Homestead...\033[0m"
env git clone "$HOMESTEAD_REPO" "$MY_HOMESTEAD"
vagrant box add laravel/homestead

echo 'Setup complete'

env zsh
