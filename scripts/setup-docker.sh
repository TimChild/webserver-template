#!/bin/bash
# Run this script on the server to set up docker and docker-compose (following the DO guide below)
# https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-22-04

set -e

function heading() {
    echo "-------"
    printf "\033[1;32m %s \033[0m \n" "$1"
    echo "-------"
}

export DEBIAN_FRONTEND=noninteractive

heading "Installing Docker"
echo "Updating package list"
sudo apt-get update -y
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common

# Add Docker’s official GPG key:
echo "Adding Docker’s official GPG key"
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor --batch --yes -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null 

# Install Docker
echo "Installing Docker"
sudo apt-get update -y
sudo apt-get install -y docker-ce

heading "Checking docker status"
sudo systemctl status docker

heading "Checking Docker version"
sudo docker version

# Add user to docker group
heading "Adding user to docker group (to run docker without sudo)"
sudo usermod -aG docker "${USER}"

heading "Installing Docker Compose"
sudo apt-get update -y
sudo apt-get install -y docker-compose-plugin

heading "Checking Docker Compose version"
docker compose version


