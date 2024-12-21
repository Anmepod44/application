#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

echo "Starting Docker installation and setup..."

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
echo "Verifying Docker installation..."
if ! command -v docker &> /dev/null; then
    echo "Docker installation failed. Exiting..."
    exit 1
fi
echo "Docker installed successfully."

# Ensure Docker daemon is running
echo "Starting Docker daemon..."
sudo systemctl start docker
sudo systemctl enable docker

# Check Docker socket permissions and set user permissions
echo "Setting up Docker socket permissions..."
sudo groupadd -f docker
sudo usermod -aG docker $USER
sudo chown root:docker /var/run/docker.sock
sudo chmod 660 /var/run/docker.sock

# Verify Docker daemon connectivity
echo "Testing Docker daemon connection..."
if ! docker run hello-world &> /dev/null; then
    echo "Cannot connect to the Docker daemon. Check daemon status and socket configuration."
    exit 1
fi
echo "Docker daemon is running and accessible."

# Install Docker Compose
echo "Installing Docker Compose..."
DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep tag_name | cut -d '"' -f 4)
if [ -z "$DOCKER_COMPOSE_VERSION" ]; then
    echo "Failed to fetch Docker Compose version. Exiting..."
    exit 1
fi
sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Verify Docker Compose installation
echo "Verifying Docker Compose installation..."
if ! command -v docker-compose &> /dev/null; then
    echo "Docker Compose installation failed. Exiting..."
    exit 1
fi
docker-compose --version
echo "Docker Compose installed successfully."

# Ensure Docker Compose setup works
if [ -f docker-compose.yml ]; then
    echo "Bringing down any running containers..."
    docker-compose down || true  # Don't exit on error in case no containers are running

    echo "Starting containers..."
    docker-compose up -d
else
    echo "No docker-compose.yml file found. Skipping container setup."
fi

echo "Installation and setup completed successfully. Please log out and log back in for user group changes to take effect."
