#!/bin/bash

apt-get update -y

apt-get install -y docker.io

systemctl enable docker

systemctl start docker

docker pull extremesantosh/three-tier-architecture-app-frontend:v3

docker run -d \
  --name frontend \
  -p 80:80 \
  --restart unless-stopped \
  extremesantosh/three-tier-architecture-app-frontend:v3