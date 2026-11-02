#!/bin/bash

# Folder where backup archives are saved and read from
BACKUP_DIR="/home/mojo/Documents/BACKUP_TO_ONLINE"

# Folder holding the live ffxivConfig directory
CONFIG_DIR="/home/mojo/.xlcore"

# Create a timestamped archive of the ffxivConfig folder
backup() {
  # Make sure the backup folder exists
  mkdir -p "$BACKUP_DIR"

  # Archive ffxivConfig and send a notification based on the result
  if tar -czf "$BACKUP_DIR/ffxivConfig_$(date +%Y%m%d_%H%M%S).tar.gz" -C "$CONFIG_DIR" ffxivConfig; then
    notify-send "FFXIV backup finished" "Saved to BACKUP_TO_ONLINE"
  else
    notify-send "FFXIV backup failed"
  fi
}

# Restore the newest archive back into the original location
restore() {
  # List all backup archives, sort by name (the timestamp makes name order
  # match date order), and keep the last one
  local latest
  latest=$(ls -1 "$BACKUP_DIR"/ffxivConfig_*.tar.gz 2>/dev/null | sort | tail -n 1)

  # If no archive was found, send a failure notification and stop
  if [ -z "$latest" ]; then
    notify-send "FFXIV restore failed" "No backup found in BACKUP_TO_ONLINE"
    exit 1
  fi

  # Ask for confirmation in a KDE dialog before changing any files
  if ! kdialog --title "Confirm restore" \
    --yesno "Restore from $(basename "$latest")?\n\nClose FFXIV first."; then
    exit 0
  fi

  # Make sure the restore location exists before extracting into the folder
  mkdir -p "$CONFIG_DIR"

  # If a current ffxivConfig folder exists, rename the folder with a timestamp
  # so the restore does not overwrite the folder
  if [ -d "$CONFIG_DIR/ffxivConfig" ]; then
    mv "$CONFIG_DIR/ffxivConfig" "$CONFIG_DIR/ffxivConfig_pre_restore_$(date +%Y%m%d_%H%M%S)"
  fi

  # Extract the latest archive. The archive contains the ffxivConfig folder,
  # so the folder is recreated in place.
  if tar -xzf "$latest" -C "$CONFIG_DIR"; then
    notify-send "FFXIV restore finished" "Restored from $(basename "$latest")"
  else
    # Extraction failed, so name the archive to restore
    notify-send "FFXIV restore failed" "Could not extract $(basename "$latest")"
    exit 1
  fi
}

# Show a KDE menu dialog. Cancel or closing the window returns a non-zero
# code, so the script exits without any action.
choice=$(kdialog --title "FFXIV Backup and Restore" \
  --menu "Select an action:" \
  backup "Backup" \
  restore "Restore") || exit 0

# Run the function matching the selection
case "$choice" in
  backup)  backup ;;
  restore) restore ;;
esac