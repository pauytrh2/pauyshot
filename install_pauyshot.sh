#!/bin/bash

# Pauyshot AppImage Installer

# Variables
REPO_URL="https://github.com/pauytrh2/pauyshot.git"
INSTALL_DIR="/usr/local/bin"
DESKTOP_FILE_PATH="/usr/share/applications/pauyshot.desktop"

# Check for root privileges
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Clone the repository
TEMP_DIR=$(mktemp -d)
echo "Cloning Pauyshot repository..."
git clone "$REPO_URL" "$TEMP_DIR" || { echo "Failed to clone repository"; exit 1; }

# Locate the AppImage
APPIMAGE=$(find "$TEMP_DIR" -name "*.AppImage" -type f | head -n 1)
if [ -z "$APPIMAGE" ]; then
    echo "No AppImage found in the repository."
    exit 1
fi

# Install the AppImage
echo "Installing Pauyshot..."
cp "$APPIMAGE" "$INSTALL_DIR/pauyshot"
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
