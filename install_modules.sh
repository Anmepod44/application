#!/bin/bash
echo "Installing dependencies..."
sudo apt-get update && sudo apt-get install -y python3 python3-pip
pip3 install flask requests
echo "Modules installed successfully."
