#!/usr/bin/env bash
###############################################################################
# setup-mac.sh – Opinionated macOS tweaker
# Tom McCarthy, 2025
#
# This script tweaks macOS settings for usability, speed, and developer sanity.
###############################################################################

set -euo pipefail

###############################################################################
# Trackpad & Mouse Settings
###############################################################################

# Max trackpad tracking speed
defaults write -g com.apple.trackpad.scaling -float 3

# Enable tap-to-click for user and login screen
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad Clicking -int 1
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
defaults write -g com.apple.mouse.tapBehavior -int 1

# Map two-finger tap to right-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadCornerSecondaryClick -int 2
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadRightClick -bool true
defaults -currentHost write -g com.apple.trackpad.trackpadCornerClickBehavior -int 1
defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadRightClick -int 1

###############################################################################
# Dock Preferences
###############################################################################

# Clear Dock and disable recents
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock show-recents -bool false

# Dock auto-hide, speed, and magnification
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0.05
defaults write com.apple.dock autohide-time-modifier -float 0.25
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock tilesize -int 54
defaults write com.apple.dock largesize -int 64

# Disable Quick Note from bottom-right hot corner
defaults write com.apple.dock wvous-br-corner -int 0
defaults write com.apple.dock wvous-br-modifier -int 0

# Restart Dock to apply changes
killall Dock

###############################################################################
# Finder Preferences
###############################################################################

# Show hidden files and ~/Library
defaults write com.apple.finder AppleShowAllFiles -bool true
chflags nohidden ~/Library

# Avoid .DS_Store on network/USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Set Finder default view to list
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# Disable extension change warning
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false

# Sort folders first
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# Show Finder status and path bars
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder ShowPathbar -bool true

# Show all filename extensions globally
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Restart Finder to apply changes
killall Finder

###############################################################################
# Keyboard & TextEdit Tweaks
###############################################################################

# Fastest keyboard repeat rates (may require logout)
defaults write -g KeyRepeat -int 1
defaults write -g InitialKeyRepeat -int 10

# Default TextEdit to plain text (UTF-8)
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4

###############################################################################
# Misc UI Tweaks
###############################################################################

# Hide Siri icon from menu bar (works on most recent macOS)
defaults write com.apple.Siri StatusMenuVisible -bool false
killall SystemUIServer

###############################################################################
# End of script – Logout may be required for some settings
###############################################################################