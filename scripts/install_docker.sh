#!/bin/bash

export VERSION_STRING=5:24.0.0-1~debian.12~bookworm

# Add Docker's official GPG key:
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg

# Add the repository to Apt sources:
echo \
    "deb [arch=$(dpkg --print-architecture) trusted=yes] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce=$VERSION_STRING docker-ce-cli=$VERSION_STRING containerd.io docker-buildx-plugin -y -qq

sudo systemctl enable --now docker

sudo usermod -aG docker debian
