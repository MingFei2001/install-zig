#!/usr/bin/env bash

##########################################################
#  ______         ___           _        _ _
# |__  (_) __ _  |_ _|_ __  ___| |_ __ _| | | ___ _ __
#   / /| |/ _` |  | || '_ \/ __| __/ _` | | |/ _ \ '__|
#  / /_| | (_| |  | || | | \__ \ || (_| | | |  __/ |
# /____|_|\__, | |___|_| |_|___/\__\__,_|_|_|\___|_|
#         |___/
##########################################################
# All credit goes to Drewgrif a.k.a. JustAGuyLinux
# Youtube Channel: https://www.youtube.com/@JustAGuyLinux
# Github Link: https://github.com/drewgrif/myghostty
##########################################################
# This should works on most debian-based system
# Please change the version to install newer version
##########################################################

# Create a temporary directory for the build
TMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TMP_DIR"

# Check if Zig is installed and at least version 0.13.0
ZIG_REQUIRED_VERSION="0.15.1"

# Function to check zig version
check_zig_version() {
    local installed_version
    installed_version=$(zig version 2>/dev/null || echo "0.0.0")
    # if [ "$(printf '%s\n' "$ZIG_REQUIRED_VERSION" "$installed_version" | sort -V | head -n1)" == "$ZIG_REQUIRED_VERSION" ]; then
    if [ "$(printf '%s\n' "$installed_version" "$ZIG_REQUIRED_VERSION" | sort -V | head -n1)" = "$ZIG_REQUIRED_VERSION" ] && [ "$installed_version" != "$ZIG_REQUIRED_VERSION" ]; then
        return 1
    else
        return 0
    fi
}

# Main Function
if command -v zig &> /dev/null && check_zig_version; then
    echo "Zig $ZIG_REQUIRED_VERSION or higher is already installed."
else
    echo "Downloading and installing Zig $ZIG_REQUIRED_VERSION..."
    cd "$TMP_DIR"

    # make sure wget is installed
    if ! command -v wget &> /dev/null; then
        echo "ERROR: 'wget' is not installed. Please install it or use 'curl'."
        exit 1
    fi

    # grab the zig binary package from the official url
    ZIG_URL="https://ziglang.org/download/$ZIG_REQUIRED_VERSION/zig-linux-x86_64-$ZIG_REQUIRED_VERSION.tar.xz"
    wget "$ZIG_URL" || { echo "ERROR: Wget download failed! Check URL or network connection."; exit 1; }

    # unpack the archive and move it to system PATH
    tar -xf "zig-linux-x86_64-$ZIG_REQUIRED_VERSION.tar.xz"
    sudo mv "zig-linux-x86_64-$ZIG_REQUIRED_VERSION" /usr/local/zig
    sudo ln -sf /usr/local/zig/zig /usr/local/bin/zig

    echo "Zig $ZIG_REQUIRED_VERSION installed successfully."
fi

# Verify Zig installation
zig version || { echo "ERROR: Zig installation failed!"; exit 1; }
echo "Zig is successfully installed and accessible."
