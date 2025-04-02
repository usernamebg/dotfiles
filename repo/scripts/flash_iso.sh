#!/bin/bash

VENTOY_SCRIPT="/sbin/ventoy"
COPY_COMMAND="rsync -rt --partial -h --progress"
DOWNLOADS_DIR="$HOME/Downloads"

# --- Script Start ---
echo "Ventoy USB Creator and ISO Copier"
echo "================================="
echo

# --- Check Prerequisites ---
if [[ $EUID -eq 0 ]]; then echo "Error: Please do not run this script as root directly."; exit 1; fi
if ! command -v "$VENTOY_SCRIPT" &> /dev/null; then echo "Error: Ventoy command '$VENTOY_SCRIPT' not found."; exit 1; fi
if ! command -v lsblk &> /dev/null; then echo "Error: 'lsblk' command not found."; exit 1; fi
if [[ "$COPY_COMMAND" == "rsync"* ]] && ! command -v rsync &> /dev/null; then
    echo "Warning: 'rsync' not found. Falling back to 'cp'."; COPY_COMMAND="cp -v --preserve=timestamps"
elif [[ "$COPY_COMMAND" == "cp"* ]] && ! command -v cp &> /dev/null; then echo "Error: 'cp' command not found."; exit 1; fi
if ! command -v find &> /dev/null; then echo "Error: 'find' command not found."; exit 1; fi
if ! command -v grep &> /dev/null; then echo "Error: 'grep' command not found."; exit 1; fi
if ! command -v awk &> /dev/null; then echo "Error: 'awk' command not found."; exit 1; fi
if ! command -v head &> /dev/null; then echo "Error: 'head' command not found."; exit 1; fi


# --- Select Target USB Drive ---
echo "Available removable block devices:"
lsblk -d -n -o NAME,SIZE,MODEL,RM | awk '$NF=="1"{printf "/dev/%-7s %-8s %s\n", $1, $2, $3}'
echo "-------------------------------------"
echo "WARNING: Choosing a drive will potentially ERASE ALL or PART of the data on it!"
TARGET_DEVICE=""
while true; do
    read -p "Enter the device name (e.g., sda, sdb): " TARGET_DEVICE_NAME
    TARGET_DEVICE="/dev/${TARGET_DEVICE_NAME}"
    if [ -b "$TARGET_DEVICE" ] && [[ $(lsblk -d -n -o RM "${TARGET_DEVICE}" 2>/dev/null) == "1" ]]; then
        MODEL=$(lsblk -d -n -o MODEL "${TARGET_DEVICE}")
        SIZE=$(lsblk -d -n -o SIZE "${TARGET_DEVICE}")
        echo "You selected: ${TARGET_DEVICE} (${MODEL} - ${SIZE})"
        break
    else
        echo "Invalid device name '$TARGET_DEVICE_NAME', not a removable block device, or doesn't exist."
        echo "Please choose from the list above (e.g., sda, sdb)."
    fi
done

# --- Check for Existing Ventoy Installation ---
echo "Checking for existing Ventoy installation on ${TARGET_DEVICE}..."
VENTOY_CHECK_OUTPUT=$(sudo "$VENTOY_SCRIPT" -l "${TARGET_DEVICE}" 2>&1)
VENTOY_CHECK_EXIT_CODE=$?
VENTOY_ACTION="install"
if [ $VENTOY_CHECK_EXIT_CODE -eq 0 ]; then
    INSTALLED_VERSION=$(echo "$VENTOY_CHECK_OUTPUT" | grep -oP 'Ventoy.* \K[0-9.]+' | head -n 1)
    if [ -n "$INSTALLED_VERSION" ]; then echo "Detected existing Ventoy installation (Version: $INSTALLED_VERSION).";
    else echo "Detected existing Ventoy installation (version unknown)."; fi
    PS3="Select action: "
    options=("Update (Safe Upgrade)" "Reinstall (Force Format Ventoy Partition)" "Skip Installation (Copy ISO Only)" "Abort")
    select opt in "${options[@]}"; do
        case $REPLY in
            1) VENTOY_ACTION="update"; break ;;
            2) VENTOY_ACTION="force_install"; break ;;
            3) VENTOY_ACTION="skip"; break ;;
            4) echo "Aborted by user."; exit 0 ;;
            *) echo "Invalid option $REPLY";;
        esac
    done
elif echo "$VENTOY_CHECK_OUTPUT" | grep -q "Disk is NOT Ventoy format"; then
    echo "No Ventoy installation found on ${TARGET_DEVICE}."
    VENTOY_ACTION="install"
else
    echo "Warning: Could not definitively determine Ventoy status (Exit code: $VENTOY_CHECK_EXIT_CODE)."
    echo "Output: $VENTOY_CHECK_OUTPUT"
    read -p "Do you want to attempt a fresh installation anyway? (yes/No): " FRESH_INSTALL_CONFIRM
    if [[ "$FRESH_INSTALL_CONFIRM" =~ ^[Yy][Ee][Ss]$ ]]; then VENTOY_ACTION="install";
    else echo "Aborted by user."; exit 1; fi
fi

# --- Confirm Action ---
echo "-------------------------------------"
case "$VENTOY_ACTION" in
    "install") echo "Action: Perform a fresh Ventoy installation on ${TARGET_DEVICE}. This will FORMAT the drive.";;
    "update") echo "Action: Attempt a safe Ventoy update on ${TARGET_DEVICE}. This should preserve existing ISO files.";;
    "force_install") echo "Action: Force reinstallation of Ventoy on ${TARGET_DEVICE}. This formats the Ventoy boot partition but SHOULD preserve the ISO partition.";;
    "skip") echo "Action: Skip Ventoy installation/update.";;
esac
if [[ "$VENTOY_ACTION" != "skip" ]]; then
    read -p "Are you ABSOLUTELY SURE you want to proceed? (yes/No): " CONFIRM_ACTION
    if [[ ! "$CONFIRM_ACTION" =~ ^[Yy][Ee][Ss]$ ]]; then echo "Aborted by user."; exit 1; fi
fi
echo "-------------------------------------"

# --- Select ISO File ---
echo "Scanning $DOWNLOADS_DIR for ISO files..."
ISO_FILES=()
while IFS= read -r -d $'\0' file; do ISO_FILES+=("$file"); done < <(find "$DOWNLOADS_DIR" -maxdepth 1 -type f \( -iname "*.iso" \) -print0)
if [ ${#ISO_FILES[@]} -eq 0 ]; then
    echo "No ISO files found in $DOWNLOADS_DIR."
    while true; do
        read -e -p "Enter the full path to the ISO file you want to copy: " ISO_FILE_PATH
        if [ -f "$ISO_FILE_PATH" ]; then echo "Using manually entered ISO file: $ISO_FILE_PATH"; break;
        else echo "Error: File not found at '$ISO_FILE_PATH'."; fi
    done
else
    echo "Found ISO files:"
    PS3="Please select the ISO file to copy: "
    select iso_choice in "${ISO_FILES[@]}"; do
        if [[ -n "$iso_choice" ]]; then ISO_FILE_PATH="$iso_choice"; echo "You selected: $ISO_FILE_PATH"; break;
        else echo "Invalid selection."; fi
    done
fi

# --- Perform Ventoy Action ---
VENTOY_EXIT_CODE=0
if [[ "$VENTOY_ACTION" != "skip" ]]; then
    echo "Unmounting partitions on ${TARGET_DEVICE} (if any)..."
    MOUNTED_PARTITIONS=$(lsblk -ln -o NAME,MOUNTPOINT "${TARGET_DEVICE}" | awk '$2!=""{print "/dev/"$1}')
    if [ -n "$MOUNTED_PARTITIONS" ]; then
        for part in $MOUNTED_PARTITIONS; do
            echo "Unmounting $part..."; sudo umount "$part" || sudo umount -l "$part" || echo "Warning: Could not unmount $part"
        done
    else echo "No mounted partitions found on ${TARGET_DEVICE}."; fi
    sleep 1
    echo "Running Ventoy command ($VENTOY_ACTION)..."
    VENTOY_CMD_ARGS=""; case "$VENTOY_ACTION" in "install") VENTOY_CMD_ARGS="-i -g";; "update") VENTOY_CMD_ARGS="-u";; "force_install") VENTOY_CMD_ARGS="-I -g";; esac
    sudo "$VENTOY_SCRIPT" $VENTOY_CMD_ARGS "${TARGET_DEVICE}"; VENTOY_EXIT_CODE=$?
    if [ $VENTOY_EXIT_CODE -ne 0 ]; then echo "Error: Ventoy operation '$VENTOY_ACTION' failed (Code: $VENTOY_EXIT_CODE)."; exit 1; fi
    echo "Ventoy operation '$VENTOY_ACTION' seems successful."
    echo "Forcing kernel to re-read partition table..."; sudo partprobe "${TARGET_DEVICE}"
    if [ $? -ne 0 ]; then echo "Warning: partprobe failed. Waiting longer..."; sleep 5; else sleep 2; fi
else
     echo "Skipping Ventoy installation/update as requested."
fi

# --- Mount Ventoy Partition and Copy ISO ---
VENTOY_PARTITION=""; echo "Attempting to detect Ventoy data partition..."
for i in {1..7}; do
    VENTOY_PARTITION=$(lsblk -lnpfo NAME,FSTYPE,LABEL "${TARGET_DEVICE}" | grep -E 'vfat|exfat|ntfs|VTOYEFI' | head -n 1 | awk '{print $1}')
    if [ -n "$VENTOY_PARTITION" ]; then echo "Detected Ventoy data partition: ${VENTOY_PARTITION}"; break; fi
    echo "Waiting for Ventoy partition to appear (${i}/7)..."; sleep 2
done
if [ -z "$VENTOY_PARTITION" ]; then
    VENTOY_PARTITION_GUESS="${TARGET_DEVICE}1"; echo "Warning: Could not auto-detect partition. Using fallback: ${VENTOY_PARTITION_GUESS}"
    if [ -b "$VENTOY_PARTITION_GUESS" ]; then VENTOY_PARTITION=$VENTOY_PARTITION_GUESS; else echo "Error: Fallback partition ${VENTOY_PARTITION_GUESS} does not exist."; exit 1; fi
fi
TEMP_MOUNT_POINT="/mnt/ventoy_temp_$(date +%s)_${RANDOM}"; echo "Creating temporary mount point: ${TEMP_MOUNT_POINT}"; sudo mkdir -p "${TEMP_MOUNT_POINT}"
if [ $? -ne 0 ]; then echo "Error: Failed to create temporary mount point."; exit 1; fi
echo "Mounting ${VENTOY_PARTITION} to ${TEMP_MOUNT_POINT}..."; sudo mount -o rw,users "${VENTOY_PARTITION}" "${TEMP_MOUNT_POINT}"
if [ $? -ne 0 ]; then echo "Error: Failed to mount Ventoy partition ${VENTOY_PARTITION}."; sudo rmdir "${TEMP_MOUNT_POINT}"; exit 1; fi
echo "Copying ISO file (This might take a while)..."; sudo $COPY_COMMAND "$ISO_FILE_PATH" "${TEMP_MOUNT_POINT}/"; COPY_EXIT_CODE=$? # Uses the updated COPY_COMMAND
echo "Ensuring data is written to disk..."; sync; sleep 1
if [ $COPY_EXIT_CODE -ne 0 ]; then echo "Error: Failed to copy ISO (Code: $COPY_EXIT_CODE)."; else echo "ISO copy seems successful."; fi

# --- Unmount and Cleanup ---
echo "Unmounting ${VENTOY_PARTITION} from ${TEMP_MOUNT_POINT}..."; sudo umount "${TEMP_MOUNT_POINT}"
if [ $? -ne 0 ]; then
    echo "Standard unmount failed, attempting lazy unmount..."; sleep 2; sudo umount -l "${TEMP_MOUNT_POINT}"
    if [ $? -ne 0 ]; then echo "Warning: Failed to unmount ${TEMP_MOUNT_POINT} even lazily.";
    else echo "Lazy unmount successful. Removing mount point."; sudo rmdir "${TEMP_MOUNT_POINT}"; fi
else echo "Unmount successful. Removing temporary mount point..."; sudo rmdir "${TEMP_MOUNT_POINT}"
     if [ $? -ne 0 ]; then echo "Warning: Could not remove ${TEMP_MOUNT_POINT} after successful unmount."; fi
fi

# --- Final Message ---
echo "---------------------------------"
if [ $COPY_EXIT_CODE -eq 0 ] && [ $VENTOY_EXIT_CODE -eq 0 ]; then
    echo "Process Complete!"
    if [[ "$VENTOY_ACTION" != "skip" ]]; then echo "Ventoy action '$VENTOY_ACTION' performed on ${TARGET_DEVICE}."; fi
    echo "ISO file '${ISO_FILE_PATH##*/}' should be copied."
    echo "You can now safely remove the USB drive and boot from it."
    exit 0
else
    echo "Process finished with errors.";
     if [ $VENTOY_EXIT_CODE -ne 0 ]; then echo " - Ventoy operation failed."; fi
     if [ $COPY_EXIT_CODE -ne 0 ]; then echo " - ISO copy failed."; fi
    exit 1
fi
