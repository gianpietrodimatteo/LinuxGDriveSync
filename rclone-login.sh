#!/bin/bash

# Rclone login script
FLAGPATH=$HOME/.config/rclone
DRIVEPATH=$HOME/GoogleDrive

# Check if the flag file from last session exists; if it does, don't proceed with sync
if [ -e "$FLAGPATH"/last_session_sync_failed ]; then
  echo "Startup sync skipped due to a previous failure. Skipping the cron job."
  echo "Pull gdrive to remove local changes and remove lockout flags, or just remove lockout flags and remove external changes."

  touch "$FLAGPATH"/no_sync_flag  # Create a flag file to signal cron job not to run
  notify-send 'Google Drive Sync' 'Login sync was not performed due to periodic sync failure.' --icon=dialog-error

  exit 0
fi

# Perform the initial sync from Google Drive to local machine
if ! rclone sync -v GoogleDrive: "$DRIVEPATH" > "$FLAGPATH"/login-log.log 2>&1;
then
  echo "Error during initial sync from Google Drive. Please check and resolve the issue."

  touch "$FLAGPATH"/no_sync_flag  # Create a flag file to signal cron job not to run
  notify-send 'Google Drive Sync' 'Login sync has failed.' --icon=dialog-error

else
  echo "Initial sync successful."

  rm -f "$FLAGPATH"/no_sync_flag  # Remove the flag file if sync is successful
  notify-send 'Google Drive Sync' 'Login sync successful.' --icon=dialog-information

fi
