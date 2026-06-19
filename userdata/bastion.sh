#!/bin/bash

set -eux

apt-get update -y

apt-get install -y \
    unzip \
    curl \
    wget \
    jq \
    postgresql-client \
    mysql-client \
    net-tools \
    telnet \
    dnsutils

# Docker
apt-get install -y docker.io

systemctl enable docker
systemctl start docker

# Useful aliases
cat <<EOF >> /home/ubuntu/.bashrc

alias ll='ls -alF'
alias k='kubectl'
alias tf='terraform'

EOF

chown ubuntu:ubuntu /home/ubuntu/.bashrc