#!/bin/bash

# Rclone script to be ran regularly and at logout
FLAGPATH=$HOME/.config/rclone
DRIVEPATH=$HOME/GoogleDrive

# Check if the flag file from the last session exists; if it does, don't proceed with sync
if [ -e "$FLAGPATH"/last_session_sync_failed ]; then
  echo "Last session sync failed. Skipping the cron job."
  exit 0
fi

# Check if the flag file exists; if it does, don't proceed with sync
if [ -e "$FLAGPATH"/no_sync_flag ]; then
  echo "Startup sync skipped due to a previous failure. Skipping the cron job."
  exit 0
fi

# Perform the sync from local machine to Google Drive
if ! rclone sync -v "$DRIVEPATH" GoogleDrive: > "$FLAGPATH"/sync-log.log 2>&1;
then
  echo "Error during sync to Google Drive. Please check and resolve the issue."
  touch "$FLAGPATH"/last_session_sync_failed  # Create a flag file to indicate last session sync failure
else
  echo "Sync to Google Drive successful."
  rm -f "$FLAGPATH"/last_session_sync_failed  # Remove the flag file if sync is successful
fi
