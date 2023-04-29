#!/bin/bash

echo "Setting up default session config ..."
cd ~
cd .config
mkdir storage-sense
cd storage-sense
wget https://raw.githubusercontent.com/omegaui/linux-storage-sense/main/bin/storage-sense-config.json

echo "Setting up autostart ..."
cd ~
cd .config/autostart
wget https://raw.githubusercontent.com/omegaui/linux-storage-sense/main/bin/linux-storage-sense.desktop

echo "** Installer Requires Administrator Permission to download and setup binaries"
echo "Downloading Storage Sense Configurator ..."
sudo wget https://raw.githubusercontent.com/omegaui/linux-storage-sense/main/bin/storage-sense-config --output-document=/usr/bin/storage-sense-config
echo "Downloading Storage Sense Daemon ..."
sudo wget https://raw.githubusercontent.com/omegaui/linux-storage-sense/main/bin/storage-sense-daemon --output-document=/usr/bin/storage-sense-daemon

sudo chmod 777 /usr/bin/storage-sense-config
sudo chmod 777 /usr/bin/storage-sense-daemon

echo "All Set!"
echo "Add some files with storage-sense-config command and then,"
echo "a system restart is required initially for the daemon to start!"