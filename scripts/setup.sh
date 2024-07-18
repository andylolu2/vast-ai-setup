#!/bin/bash

set -e

# Disable tmux auto start by vast.ai
touch ~/.no_auto_tmux;

apt update
apt install -y software-properties-common

add-apt-repository ppa:git-core/ppa
add-apt-repository ppa:fish-shell/release-3
add-apt-repository ppa:neovim-ppa/unstable
apt update

apt install -y \
    build-essential \
    curl \
    fish \
    git \
    jq \
    neovim \
    ripgrep \
    tar \
    tmux \
    wget

RUN git clone https://github.com/andylolu2/dotfiles $HOME/.dotfiles && \
    $HOME/.dotfiles/main.fish