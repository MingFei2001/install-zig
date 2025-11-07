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
cleanup() {
    echo "Cleaning up temporary directory: $TMP_DIR"
    rm -rf "$TMP_DIR"
}

TMP_DIR=$(mktemp -d)
echo "Using temporary directory: $TMP_DIR"

# Register cleanup function to run on exit
trap cleanup EXIT

# Check if Zig is installed and at least version 0.13.0
ZIG_REQUIRED_VERSION="0.15.2"

# Function to check zig version
check_zig_version() {
    local installed_version
    installed_version=$(zig version 2>/dev/null || echo "0.0.0")
    # Use the version_compare function to determine if an upgrade is needed.
    # It returns -1 if installed < required, 0 if installed = required, and 1 if installed > required.
    # We need an upgrade if installed < required (version_compare returns -1).
    case $(version_compare "$installed_version" "$ZIG_REQUIRED_VERSION") in
        -1) return 1 ;; # Installed version is less than required, so an upgrade/install is needed.
        *) return 0 ;;  # Installed version is sufficient (equal or greater).
    esac
}

# Function to compare two version strings (e.g., "0.15.0", "0.15.1")
# Returns: -1 if v1 < v2, 0 if v1 = v2, 1 if v1 > v2
version_compare() {
    if [[ -z "$1" || -z "$2" ]]; then
        echo "ERROR: version_compare requires two arguments." >&2
        exit 1
    fi
    local v1=$1
    local v2=$2

    if printf '%s\n' "$v1" "$v2" | sort -V | head -n1 | grep -q "$v1"; then
        [[ "$v1" = "$v2" ]] && echo 0 || echo -1
    else
        echo 1
    fi
}

# Main Function
if command -v zig &> /dev/null && check_zig_version; then
    echo "Zig $ZIG_REQUIRED_VERSION or higher is already installed."
    # Exit cleanly as no action is needed
    exit 0
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
