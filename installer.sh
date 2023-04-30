
echo "* The Installer requires administration access"

echo "Setting up default session config ..."
cd ~/.config
mkdir storage-sense
cd storage-sense
wget https://raw.githubusercontent.com/omegaui/linux-storage-sense/main/bin/storage-sense-config.json

echo "Setting up autostart ..."
cd ~/.config/autostart
wget https://raw.githubusercontent.com/omegaui/linux-storage-sense/main/bin/linux-storage-sense.desktop

echo "Downloading Storage Sense Configurator ..."
sudo wget https://raw.githubusercontent.com/omegaui/linux-storage-sense/main/bin/storage-sense-config --output-document=/usr/bin/storage-sense-config

echo "Stopping Daemon (if running) ..."
pkill -f storage-sense-daemon

echo "Downloading Storage Sense Daemon ..."
sudo wget https://raw.githubusercontent.com/omegaui/linux-storage-sense/main/bin/storage-sense-daemon --output-document=/usr/bin/storage-sense-daemon

sudo chmod 0755 /usr/bin/storage-sense-config
sudo chmod 0755 /usr/bin/storage-sense-daemon

echo "All Set!"
echo "Add some files with storage-sense-config command and then,"
echo "a system restart is required initially for the daemon to start!"