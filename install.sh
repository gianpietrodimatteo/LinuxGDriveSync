#!/bin/bash

# LinuxGDrive sync installer
# A Google Drive syncing tool for Linux based systems using Rclone
# Requires sudo, rclone and systemd

# Creates directories
mkdir -p ~/.config/rclone ~/bin ~/.config/systemd/user ~/GoogleDrive

# Configure rclone access tokens
echo "Read https://rclone.org/drive/"
echo "Name remote GoogleDrive"
rclone config

# Make initial sync
rclone sync -v GoogleDrive: ~/GoogleDrive

# Make sure scripts are executable
chmod +x "$(pwd)/rclone-login.sh"
chmod +x "$(pwd)/rclone-sync.sh"

# Install scripts
ln -sv "$(pwd)/rclone-login.sh" ~/bin/
ln -sv "$(pwd)/rclone-sync.sh" ~/bin/

# Install services and timer
ln -sv "$(pwd)/rclone-logout.service" ~/.config/systemd/user/
ln -sv "$(pwd)/rclone-login.service" ~/.config/systemd/user/
ln -sv "$(pwd)/rclone-sync.service" ~/.config/systemd/user/
ln -sv "$(pwd)/rclone-sync.timer" ~/.config/systemd/user/

# Enable and start services and timer
sudo systemctl enable --now rclone-sync.timer
sudo systemctl enable --now rclone-logout.service
sudo systemctl enable --now rclone-login.service
sudo systemctl daemon-reload
