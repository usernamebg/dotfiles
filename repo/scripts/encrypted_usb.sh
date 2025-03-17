#!/bin/bash
# encrypted_usb.sh
# Author: Claude
# Date: March 14, 2025
# Description: Script to mount/unmount an encrypted USB drive
# Usage: ./encrypted_usb.sh [mount|unmount]
#
# After mounting the encrypted USB drive, you can access your files using:
#
# 1. File manager (GUI method):
#    - Open your file manager
#    - Navigate to /mnt/encrypted_usb/
#    - You might need to run with sudo: sudo nautilus /mnt/encrypted_usb/
#
# 2. Terminal commands:
#    - View files:         sudo ls -la /mnt/encrypted_usb/
#    - Copy files:         sudo cp /mnt/encrypted_usb/my_private_key.asc /destination/path/
#    - Edit files:         sudo nvim /mnt/encrypted_usb/my_private_key.asc
#
# 3. Import GPG key back into your keyring (if needed):
#    - gpg --import /mnt/encrypted_usb/my_private_key.asc
#
# 4. Change ownership to access without sudo:
#    - sudo chown your_username:your_username /mnt/encrypted_usb/my_private_key.asc
#    - sudo chown your_username:your_username /mnt/encrypted_usb/revocation_certificate.asc

# Configuration
USB_DEVICE="/dev/sda1"           # Your USB device partition
MAPPER_NAME="encrypted_usb"      # Name for the decrypted mapping
MOUNT_POINT="/mnt/encrypted_usb" # Where to mount the filesystem

# Function to show usage information
show_usage() {
  echo "Usage: $0 [mount|unmount]"
  echo "  mount   - Open and mount the encrypted USB drive"
  echo "  unmount - Unmount and close the encrypted USB drive"
  exit 1
}

# Function to mount the encrypted USB
mount_encrypted_usb() {
  echo "Mounting encrypted USB drive..."

  # Check if device exists
  if [ ! -b "$USB_DEVICE" ]; then
    echo "Error: Device $USB_DEVICE not found. Is the USB drive connected?"
    exit 1
  fi

  # Check if already opened
  if [ -e "/dev/mapper/$MAPPER_NAME" ]; then
    echo "The encrypted volume is already open."
  else
    # Open the encrypted partition with LUKS
    echo "Opening encrypted partition..."
    sudo cryptsetup luksOpen "$USB_DEVICE" "$MAPPER_NAME"

    if [ $? -ne 0 ]; then
      echo "Failed to open encrypted partition. Wrong passphrase?"
      exit 1
    fi
  fi

  # Create mount point if it doesn't exist
  if [ ! -d "$MOUNT_POINT" ]; then
    echo "Creating mount point directory..."
    sudo mkdir -p "$MOUNT_POINT"
  fi

  # Check if already mounted
  if mount | grep -q "$MOUNT_POINT"; then
    echo "The encrypted volume is already mounted at $MOUNT_POINT"
  else
    # Mount the decrypted volume
    echo "Mounting filesystem..."
    sudo mount "/dev/mapper/$MAPPER_NAME" "$MOUNT_POINT"

    if [ $? -ne 0 ]; then
      echo "Failed to mount filesystem."
      echo "Closing encrypted volume..."
      sudo cryptsetup luksClose "$MAPPER_NAME"
      exit 1
    fi
  fi

  echo "Success! Your encrypted USB is mounted at $MOUNT_POINT"
  echo "Important files:"
  sudo ls -la "$MOUNT_POINT"

  echo ""
  echo "Access your files using:"
  echo "  - File manager:  sudo nautilus $MOUNT_POINT  (or your file manager of choice)"
  echo "  - View files:    sudo ls -la $MOUNT_POINT"
  echo "  - Copy a file:   sudo cp $MOUNT_POINT/filename /destination/path/"
  echo "  - Edit a file:   sudo nvim $MOUNT_POINT/filename"
  echo "  - Import GPG key: gpg --import $MOUNT_POINT/my_private_key.asc"
}

# Function to unmount the encrypted USB
unmount_encrypted_usb() {
  echo "Unmounting encrypted USB drive..."

  # Check if mounted
  if mount | grep -q "$MOUNT_POINT"; then
    echo "Unmounting filesystem..."
    sudo umount "$MOUNT_POINT"

    if [ $? -ne 0 ]; then
      echo "Failed to unmount filesystem. Make sure no files are open."
      exit 1
    fi
  else
    echo "The volume is not mounted at $MOUNT_POINT"
  fi

  # Check if mapper exists
  if [ -e "/dev/mapper/$MAPPER_NAME" ]; then
    echo "Closing encrypted volume..."
    sudo cryptsetup luksClose "$MAPPER_NAME"

    if [ $? -ne 0 ]; then
      echo "Failed to close encrypted volume."
      exit 1
    fi
  else
    echo "The encrypted volume is not open."
  fi

  echo "Success! Your encrypted USB is safely unmounted."
}

# Main script logic
case "$1" in
mount)
  mount_encrypted_usb
  ;;
unmount)
  unmount_encrypted_usb
  ;;
*)
  show_usage
  ;;
esac

exit 0
