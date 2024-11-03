#!/bin/bash

# Disable tmux auto start by vast.ai
touch ~/.no_auto_tmux

apt update
apt install -y software-properties-common

add-apt-repository -y ppa:git-core/ppa
add-apt-repository -y ppa:fish-shell/release-3
add-apt-repository -y ppa:neovim-ppa/unstable
apt update

apt install -y \
    build-essential \
    curl \
    fish \
    git \
    htop \
    jq \
    neovim \
    nvtop \
    ripgrep \
    tar \
    tmux \
    wget

# Setup git
git config --global user.email "andylolu24@gmail.com"
git config --global user.name "andylolu2"

# Setup fish as default shell + styling
git clone https://github.com/andylolu2/dotfiles ~/.dotfiles
~/.dotfiles/main.fish

# Add github.com to known hosts to avoid confirmation when cloning with ssh
ssh-keyscan github.com >> ~/.ssh/known_hosts

# Update paths for fish
fish -c "fish_add_path /usr/local/nvidia/bin /usr/local/cuda/bin /opt/conda/bin /usr/local/nvidia/bin /usr/local/cuda/bin"

mkdir -p ~/.bin ~/.local/bin
