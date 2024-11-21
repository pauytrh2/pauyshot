#!/bin/bash

# Pauyshot AppImage Installer (File.io)

# Variables
APPIMAGE_URL="https://file.io/GgjXJuM4ykFy"
INSTALL_DIR="/usr/local/bin"
DESKTOP_FILE_PATH="/usr/share/applications/pauyshot.desktop"

# Check for root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Download the AppImage
TEMP_DIR=$(mktemp -d)
APPIMAGE_PATH="$TEMP_DIR/pauyshot.AppImage"
echo "Downloading Pauyshot AppImage..."
curl -L -o "$APPIMAGE_PATH" "$APPIMAGE_URL" || { echo "Failed to download AppImage"; exit 1; }

# Install the AppImage
echo "Installing Pauyshot..."
cp "$APPIMAGE_PATH" "$INSTALL_DIR/pauyshot"
chmod +x "$INSTALL_DIR/pauyshot"

# Create a .desktop entry
echo "Creating .desktop entry..."
cat <<EOF > "$DESKTOP_FILE_PATH"
[Desktop Entry]
Name=Pauyshot
Exec=$INSTALL_DIR/pauyshot
Icon=application-x-executable
Type=Application
Categories=Game;
EOF

chmod 644 "$DESKTOP_FILE_PATH"

# Cleanup
rm -rf "$TEMP_DIR"

echo "Pauyshot AppImage installed successfully!"
echo "You can now run it by typing 'pauyshot' in the terminal or using the application menu."
