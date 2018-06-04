#!/bin/sh

set -e

echo "\033[1;35mConfiguring ZSH...\033[0m"
mv "$MY_HOME/.zshrc" "$MY_HOME/old.zshrc"
ln -s "$YO_ZSH/zshrc" "$MY_HOME/.zshrc"
ln -s "$YO_ZSH" "$MY_ZSH"
