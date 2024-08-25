#!/bin/bash

# Define variables for paths and files
ARCHINSTALL_CMD="archinstall"
MOUNT_POINT="/mnt"
OS_RELEASE_SOURCE="os-release"

# Function to check the exit status of the previous command
check_status() {
    if [ $? -ne 0 ]; then
        echo "Error: $1"
        exit 1
    fi
}

# Run the archinstall script
echo "Running archinstall..."
$ARCHINSTALL_CMD
check_status "Arch installation failed."

# Ensure the mount point is correct and accessible
if [ ! -d "$MOUNT_POINT" ]; then
    echo "Error: Mount point $MOUNT_POINT does not exist."
    exit 1
fi

# Copy custom os-release file to the new system
cp "$OS_RELEASE_SOURCE" "$MOUNT_POINT/etc/os-release"
check_status "Failed to copy os-release."

# Append custom repository to pacman.conf
arch-chroot "$MOUNT_POINT" bash -c "echo '[archianos]' >> /etc/pacman.conf"
arch-chroot "$MOUNT_POINT" bash -c "echo 'SigLevel = Optional TrustAll' >> /etc/pacman.conf"
arch-chroot "$MOUNT_POINT" bash -c "echo 'Server = https://github.com/ArchianOS/archianos-repo/raw/main/x86_64/' >> /etc/pacman.conf"
check_status "Failed to update pacman.conf."

# Done
echo "ArchianOS installation and configuration completed successfully."
