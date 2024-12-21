#!/bin/bash

echo "Starting installation..."

# Update system and install prerequisites
echo "Updating system and installing prerequisites..."
sudo apt-get update && sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common

# Install Docker
echo "Installing Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update && sudo apt-get install -y docker-ce docker-ce-cli containerd.io

# Verify Docker installation
if ! command -v docker &> /dev/null; then
    echo "Docker installation failed. Exiting..."
    exit 1
fi
echo "Docker installed successfully."

# Install Docker Compose
echo "Installing Docker Compose..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify Docker Compose installation
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose installation failed. Exiting..."
    exit 1
fi
echo "Docker Compose installed successfully."

# Perform Docker Compose down and up
echo "Bringing down any running containers..."
docker-compose down

echo "Starting containers..."
docker-compose up -d

echo "Installation and setup completed."
