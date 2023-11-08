#!/bin/bash

GIT_NAME=''
GIT_EMAIL=''

sudo apt-get install bison \
                     g++-multilib \
                     git \
                     gperf \
                     libxml2-utils \
                     make \
                     zlib1g-dev:i386 \
                     zip \
                     liblz4-tool \
                     libncurses5 \
                     libssl-dev \
                     bc \
                     flex \
                     curl \
                     zlib1g-dev \
                     libelf-dev

mkdir ~/bin
curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > ~/bin/repo
chmod a+x ~/bin/repo
echo -e "export PATH=~/bin:$PATH" >> ~/.bashrc

git config --global user.email "$GIT_EMAIL"
git config --global user.name "$GIT_NAME"

git lfs install