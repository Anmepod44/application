#!/bin/bash
echo "Starting installation..."

# Update system and install dependencies
sudo apt-get update && sudo apt-get install -y python3 python3-pip
pip3 install flask requests

echo "Checking modules for dependencies..."
for module in /application/modules/*; do
    if [ -f "$module/requirements.txt" ]; then
        echo "Installing dependencies for module $module..."
        pip3 install -r "$module/requirements.txt"
    fi
done

echo "Installation completed."
