#!/bin/bash
# Run this script on the server to set up general configuration including:
# - Setting max journal size to 300MB
# - Setting timezone to US/Pacific
# - Setting up a swapfile (useful for vps's with small ram)

function heading() {
    echo "-------"
    printf "\033[1;32m %s \033[0m \n" "$1"
    echo "-------"
}

heading "Setting up general configuration"

heading "Setting max journal size to 300MB"
sed -i 's/#SystemMaxUse=/SystemMaxUse=300M/' /etc/systemd/journald.conf

heading "Setting timezone to US/Pacific"
timedatectl set-timezone US/Pacific

heading "Setting up swapfile"
sudo fallocate -l 1G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
echo "/swapfile swap swap defaults 0 0" | sudo tee -a /etc/fstab

echo "Configuring swappiness"
sudo sysctl vm.swappiness=10
echo "vm.swappiness=10" | sudo tee -a /etc/sysctl.conf

echo "Configuring cache pressure"
sudo sysctl vm.vfs_cache_pressure=50
echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.conf

sudo swapon --show
heading "Swapfile setup complete"

echo "Set automatic vacuuming of journal logs"
vacuum_job="journalctl --vacuum=100M"
# Once a day at 2:30am
crontab -l | grep -q "$vacuum_job" || (crontab -l ; echo "30 2 * * * $vacuum_job") | crontab -

echo "Set automatic apt cleanup"
apt_clean_job="apt autoclean -y && apt autoremove -y"
# Once a week on Monday at 3:30am
crontab -l | grep -q "$apt_clean_job" || (crontab -l ; echo "30 3 * * 1 $apt_clean_job") | crontab -

heading "Done setting up general configuration"

