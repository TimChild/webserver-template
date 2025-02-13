#!/bin/bash
# Run this on the server to set up basic security measures including:
# - Creating a non-root user ('webadmin') with sudo privileges
# - Setting up UFW firewall
# - Disallowing root login and password authentication
# - Updating/Upgrading packages
#
# https://www.digitalocean.com/community/tutorials/initial-server-setup-with-ubuntu
# https://www.digitalocean.com/community/tutorials/recommended-security-measures-to-protect-your-servers

function heading() {
    echo "-------"
    printf "\033[1;32m %s \033[0m \n" "$1"
    echo "-------"
}

set -e
heading "Connected to droplet"

heading "Checking if webadmin user exists"
if id "webadmin" &>/dev/null; then
    echo "User 'webadmin' already exists"
    exit 1
else
    echo "Creating non-root user with sudo privileges: 'webadmin'"
    adduser --disabled-password --gecos "" webadmin 
    usermod -aG sudo webadmin

    echo "Allowing passwordless sudo"
    echo "webadmin ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/webadmin

    echo "Copying SSH keys to new user"
    rsync --archive --chown=webadmin:webadmin ~/.ssh /home/webadmin
fi


heading "Setting up UFW firewall"
ufw allow OpenSSH
ufw --force enable


heading "Configuring SSH"
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
echo "   Disallowing root login"
sed -i 's/PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
echo "   Disallowing password authentication"
sed -i 's/PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
echo "   Restarting SSH"
systemctl restart ssh

heading "Updating/Upgrading packages"
apt-get update > /dev/null
apt-get upgrade -y > /dev/null


heading "Droplet setup complete"


