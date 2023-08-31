#!/bin/bash

# Rclone login script
FLAGPATH=$HOME/.config/rclone
DRIVEPATH=$HOME/GoogleDrive

# Check if the flag file from the last session exists; if it does, don't proceed with sync
if [ -e "$FLAGPATH"/last_session_sync_failed ]; then
  echo "Last session sync failed. Skipping the startup sync."
  touch "$FLAGPATH"/no_sync_flag  # Create a flag file to signal cron job not to run
  exit 0
else
  echo "Last session sync was successful."
  rm -f "$FLAGPATH"/no_sync_flag  # Remove the flag file to allow the cron job to run
fi

# Perform the initial sync from Google Drive to local machine
if ! rclone sync -v GoogleDrive: "$DRIVEPATH" > "$FLAGPATH"/login-log.log 2>&1;
then
  echo "Error during initial sync from Google Drive. Please check and resolve the issue."
  touch "$FLAGPATH"/no_sync_flag  # Create a flag file to signal cron job not to run
else
  echo "Initial sync successful."
  rm -f "$FLAGPATH"/no_sync_flag  # Remove the flag file if sync is successful
fi
