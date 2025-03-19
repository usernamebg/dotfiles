#!/bin/bash
# Configuration
PASSWORD_STORE="$HOME/.password-store"
ENCRYPTED_USB_SCRIPT="$HOME/repo/scripts/encrypted_usb.sh"
BACKUP_DIR="/mnt/encrypted_usb/password-store-backup"

# Check if password-store exists
if [ ! -d "$PASSWORD_STORE" ]; then
  echo "Error: Password store not found at $PASSWORD_STORE"
  exit 1
fi

# Check if encrypted_usb script exists
if [ ! -f "$ENCRYPTED_USB_SCRIPT" ]; then
  echo "Error: encrypted_usb.sh script not found at $ENCRYPTED_USB_SCRIPT"
  exit 1
fi

# Mount the encrypted USB
echo "Mounting encrypted USB drive..."
"$ENCRYPTED_USB_SCRIPT" mount

# Check if mounting was successful
if [ $? -ne 0 ]; then
  echo "Failed to mount encrypted USB. Aborting sync."
  exit 1
fi

# Create backup directory if it doesn't exist
if [ ! -d "$BACKUP_DIR" ]; then
  echo "Creating backup directory on USB..."
  sudo mkdir -p "$BACKUP_DIR"

  # Set proper permissions so we can write to it without sudo
  sudo chown $(whoami):$(whoami) "$BACKUP_DIR"
fi

# Sync password store to USB
echo "Syncing password store to encrypted USB..."
rsync -av --delete "$PASSWORD_STORE/" "$BACKUP_DIR/"

# Check if sync was successful
if [ $? -eq 0 ]; then
  echo "Password store successfully synced to $BACKUP_DIR"

  # Show backup stats
  echo "Backup summary:"
  echo "----------------"
  echo "Total passwords: $(find "$BACKUP_DIR" -name "*.gpg" | wc -l)"
  echo "Last backup: $(date)"
  echo "Backup location: $BACKUP_DIR"
  echo "----------------"
else
  echo "Error: Failed to sync password store."
fi

# Ask if user wants to unmount USB now
read -p "Do you want to unmount the encrypted USB now? (y/n): " unmount_choice
if [[ "$unmount_choice" == "y" || "$unmount_choice" == "Y" ]]; then
  echo "Unmounting encrypted USB..."
  "$ENCRYPTED_USB_SCRIPT" unmount
else
  echo "USB remains mounted at /mnt/encrypted_usb"
  echo "Remember to unmount it later with: $ENCRYPTED_USB_SCRIPT unmount"
fi

exit 0
