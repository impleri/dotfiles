#!/bin/sh

echo "\033[0;37mInstalling Homebrew...\033[0m"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

echo "\033[1;35mInstalling base tools...\033[0m"
brew install node watchman yarn
brew install --cask docker hyper google-chrome visual-studio-code

echo "\033[1;35mInstalling RN tools...\033[0m"
sudo gem install cocoapods
brew install --cask adoptopenjdk/openjdk/adoptopenjdk8 android-studio
