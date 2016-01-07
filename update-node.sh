#!/bin/sh

set -e

NODEJS_VERSION="4.2.4"

MY_HOME="$HOME"
if [ -z "$MY_HOME" ]; then
    MY_HOME="~"
fi
MY_NODE="$MY_HOME/.nodejs"
OLD_NODE="$MY_HOME/.nodejs.old"
NODE_LIST="$MY_HOME/npm-list.txt"

PACKAGES_BUILD="bower brunch coffee-script phonegap scaffolt stylus webpack"
PACKAGES_TEST="casper-chai casperjs chai coffeelint jshint mocha mocha-casperjs phantomjs@1.9.7-15"
PACKAGES_UTIL="nib scaffolt sow swagger-ui"

if [ -d "$OLD_NODE" ]; then
    echo "\033[0;32mRemoving old backup copy of Node...\033[0m"
    rm -rf $OLD_NODE
fi

# Backup existing node
if [ -d "$MY_NODE" ]; then
    echo "\033[0;32mBacking up existing copy of Node...\033[0m"
    echo "\033[0;32mExporting a list of global packages to $NODE_LIST...\033[0m"
    npm -g ls --depth=0 > "$NODE_LIST"
    mv $MY_NODE $OLD_NODE
fi

# Set up node
echo "\033[0;32mInstalling NodeJS $NODEJS_VERSION into userland...\033[0m"
wget "http://nodejs.org/dist/v$NODEJS_VERSION/node-v$NODEJS_VERSION-linux-x64.tar.gz"
tar xzf "node-v$NODEJS_VERSION-linux-x64.tar.gz"
rm "node-v$NODEJS_VERSION-linux-x64.tar.gz"
mv "node-v$NODEJS_VERSION-linux-x64" "$MY_NODE"

echo "\033[0;32mInstalling global Node packages...\033[0m"
npm -g install $PACKAGES_BUILD
npm -g install $PACKAGES_UTIL
npm -g install $PACKAGES_TEST

