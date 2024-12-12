#!/bin/bash

# Variables
DOWNLOAD_URL="https://drive.usercontent.google.com/download?id=1KmQOc2JUsnst9cN7QbknE-76ICL2sPep&export=download&authuser=0&confirm=t&uuid=fc285bc2-8119-4fea-bf9b-542385861c6e&at=APvzH3oTVhXg_C_hCQYg81x7Izuh:1733665430320"
APPIMAGE_NAME="pauyshot.AppImage"
INSTALL_DIR="/usr/local/bin"
TMP_DIR=$(mktemp -d)

# Functions
cleanup() {
    echo "Cleaning up temporary files..."
    rm -rf "$TMP_DIR"
}

# Ensure the script cleans up on exit
trap cleanup EXIT

echo "Downloading Pauyshot AppImage..."
if wget -O "$TMP_DIR/$APPIMAGE_NAME" "$DOWNLOAD_URL"; then
    echo "Download completed!"
else
    echo "Error: Download failed."
    exit 1
fi

# Verify if the downloaded file is an AppImage
if file "$TMP_DIR/$APPIMAGE_NAME" | grep -q 'ELF 64-bit LSB executable'; then
    echo "File verified as a valid AppImage."
else
    echo "Error: The downloaded file is not a valid AppImage."
    exit 1
fi

echo "Installing Pauyshot..."
sudo mv "$TMP_DIR/$APPIMAGE_NAME" "$INSTALL_DIR/pauyshot"
sudo chmod +x "$INSTALL_DIR/pauyshot"

echo "Creating .desktop entry..."
cat <<EOF | sudo tee /usr/share/applications/pauyshot.desktop > /dev/null
[Desktop Entry]
Name=Pauyshot
Exec=$INSTALL_DIR/pauyshot
Type=Application
Terminal=false
Icon=
EOF

echo "Pauyshot installed successfully!"
echo "You can now run it by typing 'pauyshot' in the terminal or using the application menu."
