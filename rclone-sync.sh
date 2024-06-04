#!/bin/bash

# Rclone script to be ran regularly and at logout
FLAGPATH=$HOME/.config/rclone
DRIVEPATH=$HOME/GoogleDrive

# Check if the startup sync failure flag file exists; if it does, don't proceed with sync
if [ -e "$FLAGPATH"/no_sync_flag ]; then
  echo "Periodical sync skipped due to a previous failure."
  exit 0
fi

# Perform the sync from local machine to Google Drive
if ! rclone sync -v "$DRIVEPATH" GoogleDrive: > "$FLAGPATH"/sync-log.log 2>&1;
then
 echo "Error during sync to Google Drive. Please check and resolve the issue."

 touch "$FLAGPATH"/last_session_sync_failed  # Create a flag file to indicate last session sync failure
 notify-send 'Google Drive Sync' 'Periodic sync has failed.' --icon=dialog-error

else
  echo "Sync to Google Drive successful."
  if [ -e "$FLAGPATH"/last_session_sync_failed ]; then

    rm -f "$FLAGPATH"/last_session_sync_failed  # Remove the flag file if sync is successful
    notify-send 'Google Drive Sync' 'Periodic sync has resumed working.' --icon=dialog-information

  fi
fi
