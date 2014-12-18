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
MY_HOME="~"
MY_BIN="$MY_HOME/.bin"
MY_ZSH="$MY_HOME/.its-my-zsh"
MY_NODE="$MY_HOME/.nodejs"
MY_SSH="$MY_HOME/.ssh"
MY_SUBL="$MY_HOME/.config/sublime-text-3/Packages"

# Install BASH aliases (in case ZSH isn't available)
ln -s $YO_BASH/bash_aliases $MY_HOME/.bash_aliases
ln -s $YO_BASH/bash_completion $MY_HOME/.bash_completion
ln -s $YO_BASH/bash_colours $MY_HOME/.bash_colours
ln -s $YO_BASH/bash_prompt $MY_HOME/.bash_prompt

# Install ZSH
chsh -s `which zsh`
ln -s $YO_ZSH/zshrc $MY_HOME/.zshrc
ln -s $YO_ZSH $MY_ZSH

# Set up .bin
if [-d $MY_BIN]
    mkdir $MY_BIN
fi
ln -s $YO/drush/backport $MY_BIN/backport

# Set up composer
curl -sS https://getcomposer.org/installer | php -- --filename=composer
mv composer $MY_BIN
composer global require phpunit/phpunit
composer global require squizlabs/php_codesniffer
composer global require fabpot/php-cs-fixer
composer global require phpmd/phpmd

# Set up node
wget http://nodejs.org/dist/v0.10.34/node-v0.10.34-linux-x64.tar.gz
tar xzf node-v0.10.34-linux-x64.tar.gz
mv node-v0.10.34-linux-x64 $MY_NODE
rm node-v0.10.34-linux-x64.tar.gz
npm -g install bower brunch coffee-script coffeelint jshint mocha nib sow stylus

# Set up git
ln -s $YO_GIT/gitignore $MY_HOME/.gitignore
ln -s $YO_GIT/gitconfig $MY_HOME/.gitconfig

# Set up SSH
if [-d $MY_SSH]
    mkdir $MY_SSH
fi
mkdir ~/.ssh/controlmasters
ln -s $YO_SSH/ssh_config $MY_SSH/ssh_config

# Set up Sublime Text
if [-d $MY_SUBL]
    mkdir -p $MY_SUBL
    mkdir -p $MY_SUBL/User
    mkdir -p $MY_SUBL/Colorsublime
fi
ln -s $YO_SUBL/*.sublime-* $MY_SUBL/User/
wget http://colorsublime.com/theme/download/27550 -O $MY_SUBL/Colorsublime/Vibrant-Ink.tmTheme

echo 'Setup complete'
echo 'Remember to install vagrant and virtualbox'
