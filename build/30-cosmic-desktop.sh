#!/usr/bin/bash

set -eoux pipefail

###############################################################################
# Example: Swap GNOME Desktop with COSMIC Desktop
###############################################################################
# This example demonstrates replacing the GNOME desktop environment with
# System76's COSMIC desktop from their COPR repository.
#
# COSMIC is a new desktop environment built in Rust by System76.
# https://github.com/pop-os/cosmic-epoch
#
# To use this script:
# 1. Rename to remove .example extension: mv 30-cosmic-desktop.sh.example 30-cosmic-desktop.sh
# 2. Build - scripts run in numerical order automatically
#
# WARNING: This removes GNOME and replaces it with COSMIC. Only use this if
# you want COSMIC as your desktop environment instead of GNOME.
###############################################################################

# Source helper functions
# shellcheck source=/dev/null
source /ctx/build/copr-helpers.sh

echo "::group:: Install COSMIC Desktop"

# Install COSMIC desktop from System76's COPR
# Using isolated pattern to prevent COPR from persisting
dnf5 install -y @cosmic-desktop-environment

echo "COSMIC desktop installed successfully"
echo "::endgroup::"

echo "::group:: Configure Display Manager"

# Enable cosmic-greeter (COSMIC's display manager)
systemctl enable cosmic-greeter

# Set COSMIC as default session
mkdir -p /etc/X11/sessions
cat > /etc/X11/sessions/cosmic.desktop << 'COSMICDESKTOP'
[Desktop Entry]
Name=COSMIC
Comment=COSMIC Desktop Environment
Exec=cosmic-session
Type=Application
DesktopNames=COSMIC
COSMICDESKTOP

echo "Display manager configured"
echo "::endgroup::"

echo "::group:: Install Additional Utilities"

# Install additional utilities that work well with COSMIC
dnf5 install -y \
    kitty \
    flatpak \
    xdg-desktop-portal-cosmic

echo "Additional utilities installed"
echo "::endgroup::"

echo "COSMIC desktop installation complete!"
echo "After booting, select 'COSMIC' session at the login screen"
