<p align="center" display="inline-block">
    <img src="https://rclone.org/img/logo_on_light__horizontal_color.svg" width="200" height="200">
    <img src="https://upload.wikimedia.org/wikipedia/commons/d/da/Google_Drive_logo.png" width="200" height="200">
</p>

# LinuxGDriveSync

[Rclone](https://rclone.org/) setup for syncing Google Drive to Linux system.

## Requirements

Requires rclone, systemd and libnotify. Also, access to your Google Drive API.

## Installation

Read rclone-login.sh and rclone-sync.sh. Read and run install.sh and follow instructions.

## How does it work?

On startup, it brings the alterations from the cloud to the local machine.
On logout, and periodically every 5 minutes, it sends from the local machine to the cloud.
If something goes wrong with any of the scripts it creates a file to lock the behaviour.
While the periodical script will keep re-trying to sync, the startup sync does not unlock
automatically, requiring user to perform the sync manually and remove the locking flag file.
