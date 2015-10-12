#!/bin/sh

set -e

# Target paths
MY_HOME="$HOME"
if [ -z "$MY_HOME" ]; then
    MY_HOME="~"
fi
MY_NODE="$MY_HOME/.nodejs"

# Other variables
NODEJS_VERSION="0.12.7"

# Set up node
if [ ! -z "$MY_NODE" ]; then
    echo "\033[0;32mRemoving existing NodeJS from userland...\033[0m"
    rm -rf $MY_NODE
fi

echo "\033[0;32mInstalling NodeJS into userland and global Node packages...\033[0m"
wget "http://nodejs.org/dist/v$NODEJS_VERSION/node-v$NODEJS_VERSION-linux-x64.tar.gz"
tar xzf "node-v$NODEJS_VERSION-linux-x64.tar.gz"
rm "node-v$NODEJS_VERSION-linux-x64.tar.gz"
mv "node-v$NODEJS_VERSION-linux-x64" "$MY_NODE"

echo "\033[0;32mInstalling global Node packages...\033[0m"
npm -g install bower brunch coffee-script coffeelint cordova jshint mocha mocha-phantomjs phantomjs@1.9.7-15 phonegap nib scaffolt sow stylus
