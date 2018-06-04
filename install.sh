#!/bin/sh

set -e

# Source paths
export YO=`pwd`
export YO_BASH="$YO/bash"
export YO_ZSH="$YO/zsh"
export YO_GIT="$YO/git"
export YO_SSH="$YO/ssh"
export YO_SUBL="$YO/sublime-text"
export YO_HOMESTEAD="$YO/.homestead"

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
export MY_HOMESTEAD="$MY_HOME/.homestead"

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

# Run O/S specific install
if [ -d "/Users" ]; then
    export MY_SUBL="$MY_HOME/Library/Application\ Support/Sublime\ Text\ 3"
  	./install_mac.sh
else
	./install_linux.sh
fi

# Set up .bin
echo "\033[0;37mCreating local executables...\033[0m"
if [ ! -d "$MY_BIN" ]; then
    mkdir "$MY_BIN"
fi

# Set up composer
echo "\033[0;32mGetting composer and global PHP packages...\033[0m"
curl -sS https://getcomposer.org/installer | php
mv composer.phar "$MY_BIN"
composer global require phpunit/phpunit
composer global require squizlabs/php_codesniffer
composer global require fabpot/php-cs-fixer
composer global require phpmd/phpmd
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
ln -s "$YO_SUBL/*.sublime-*" "$MY_SUBL_PKG/User/"

# Set up Homestead
vagrant box add laravel/homestead
ln -s "$YO_HOMESTEAD" "$MY_HOMESTEAD"
homestead up

echo 'Setup complete'
