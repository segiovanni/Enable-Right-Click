#!/bin/bash
# Configure Magic Mouse Properties

# MARK: - Variables
# -----------------

logFile="/var/log/ripeda_setup.log"

echo "######################################" >> "$logFile"
echo "Initializing Magic Mouse Configuration" >> "$logFile"
echo "######################################" >> "$logFile"

# MARK: Populate base information on current user
# -----------------------------------------------
currentUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ { print $3 }' )
uid=$(id -u "${currentUser}")

echo "Current User: $currentUser (UID: $uid)" >> "$logFile"

# MARK: - Main
# ------------

_runAsUser() {
	if [[ "${currentUser}" != "loginwindow" ]]; then
		launchctl asuser "$uid" sudo -u "${currentUser}" "$@"
	else
		echo "No user logged in, exiting..." >> "$logFile"
		exit 1
	fi
}

echo "Setting Right Click Settings" >> "$logFile"
_runAsUser /usr/bin/defaults write com.apple.driver.AppleBluetoothMultitouch.mouse MouseButtonMode TwoButton
_runAsUser /usr/bin/defaults write com.apple.AppleMultitouchMouse MouseButtonMode TwoButton

echo "Restarting Bluetooth" >> "$logFile"
pkill bluetoothd