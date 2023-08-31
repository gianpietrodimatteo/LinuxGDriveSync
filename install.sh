#!/bin/bash

# LinuxGDriveSync installer
# A Google Drive syncing tool for Linux based systems using Rclone
# Requires rclone and systemd

rmCp() {
    rm -f "$2"
    cp "$1" "$2"
}

echo "Installing LinuxGDriveSync"

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
rmCp "$(pwd)/rclone-login.sh" ~/bin/rclone-login.sh
rmCp "$(pwd)/rclone-sync.sh" ~/bin/rclone-sync.sh

# Install services and timer
rmCp "$(pwd)/rclone-logout.service" ~/.config/systemd/user/rclone-logout.service
rmCp "$(pwd)/rclone-login.service" ~/.config/systemd/user/rclone-login.service
rmCp "$(pwd)/rclone-sync.service" ~/.config/systemd/user/rclone-sync.service
rmCp "$(pwd)/rclone-sync.timer" ~/.config/systemd/user/rclone-sync.timer

# Enable and start services and timer
systemctl --user enable --now rclone-sync.timer
systemctl --user enable --now rclone-logout.service
systemctl --user enable --now rclone-login.service
