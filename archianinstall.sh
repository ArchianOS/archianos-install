#!/bin/bash

# Define variables for paths and files
ARCHINSTALL_CMD="archinstall"
MOUNT_POINT="/mnt/archinstall"

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

# Create and write the custom os-release file to the new system
cat <<EOF > "$MOUNT_POINT/etc/os-release"
NAME="ArchianOS"
PRETTY_NAME="ArchianOS"
ID=arch
VERSION_ID="2024.08.01"
HOME_URL="https://www.archianos.org/"
SUPPORT_URL="https://archianos.org/"
BUG_REPORT_URL="https://archianos.org/"
EOF
check_status "Failed to create os-release."

# Append custom repository to pacman.conf in the new system
echo '[archianos]' >> $MOUNT_POINT/etc/pacman.conf
echo 'SigLevel = Optional TrustAll' >> $MOUNT_POINT/etc/pacman.conf
echo 'Server = https://github.com/ArchianOS/archianos-repo/raw/main/x86_64/' >> $MOUNT_POINT/etc/pacman.conf
check_status "Failed to update pacman.conf."

# Rename OS in bootloader
if [ -d "$MOUNT_POINT/boot/grub" ]; then

    # Rename the Arch Linux entry in GRUB
    sudo sed -i 's/Arch Linux/ArchianOS/g' $MOUNT_POINT/boot/grub/grub.cfg

elif [ -d "$MOUNT_POINT/boot/loader" ]; then

    # Rename the Arch Linux entry in systemd-boot
    for file in $MOUNT_POINT/boot/loader/entries/*.conf; do
        if grep -q "Arch Linux" "$file"; then
            sudo sed -i 's/Arch Linux/ArchianOS/g' "$file"
        fi
    done

fi

# Done
echo "ArchianOS installation and configuration completed successfully."
