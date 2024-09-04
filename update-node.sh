#!/bin/sh

set -e

LTS_VERSION=$(curl https://nodejs.org/dist/index.json | jq -r 'map(select(.lts))[0].version')
LATEST_VERSION=$(curl https://nodejs.org/dist/index.json | jq -r '.[0].version')
NODEJS_VERSION=$LTS_VERSION

MY_HOME="$HOME"
if [ -z "$MY_HOME" ]; then
    MY_HOME="~"
fi
MY_NODE="$MY_HOME/.nodejs"
OLD_NODE="$MY_HOME/.nodejs.old"
NODE_LIST="$MY_HOME/npm-list.txt"

PACKAGES=""

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
echo "\033[0;32mInstalling NodeJS $NODEJS_VER SION into userland...\033[0m"
if [ -d "/Users" ]; then
  wget -O "node-$NODEJS_VERSION.tar.gz" "http://nodejs.org/dist/$NODEJS_VERSION/node-$NODEJS_VERSION-darwin-x64.tar.gz"
else
  wget -O "node-$NODEJS_VERSION.tar.gz" "http://nodejs.org/dist/$NODEJS_VERSION/node-$NODEJS_VERSION-linux-x64.tar.gz"
fi

tar xzf "node-$NODEJS_VERSION.tar.gz"
rm "node-$NODEJS_VERSION.tar.gz"
mv "node-$NODEJS_VERSION" "$MY_NODE"

if [ ! -z "$PACKAGES" ]; then
    echo "\033[0;32mInstalling global Node packages...\033[0m"
    npm -g install $PACKAGES
fi
