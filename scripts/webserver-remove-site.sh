#!/bin/bash
# Run on the server to remove a site from the webserver
# Args:
# - site_name: name of the site to remove
# 
# What this script does:
# - Delete directories in the ~/sites and /srv/www
# - Removes the caddy config in ~/sites-enabled
# - Restarts caddy


function heading() {
    echo "-------"
    printf "\033[1;32m %s \033[0m \n" "$1"
    echo "-------"
}

function warning() {
    echo "-------"
    printf "\033[1;33m WARNING: %s \033[0m \n" "$1"
    echo "-------"
}

set -e

site_name=$1

if [ -z "$site_name" ]; then
    echo "Usage: remove-webserver-static-site.sh <site_name>"
    exit 1
fi

heading "Removing site ($site_name)"

# Check that the site does not already exist on the webserver (where it is actually served)
if "[ ! -d /srv/www/$site_name ]"; then
    warning "/srv/www/$site_name does not exists on the webserver"
else
    ssh $ssh_name "sudo rm -rf /srv/www/$site_name"
fi

if "[ ! -d ~/sites/$site_name ]"; then
    warning "~/sites/$site_name does not exists on the webserver"
else
    ssh $ssh_name "rm -rf ~/sites/$site_name"
fi

if "[ ! -f ~/sites-enabled/$site_name.caddy ]"; then
    warning "~/sites-enabled/$site_name.caddy does not exists on the webserver"
else
    ssh $ssh_name "rm -f ~/sites-enabled/$site_name.caddy"
fi

echo "Reloading caddy..."
docker compose exec caddy caddy reload --config /etc/caddy/Caddyfile

heading "Successfully removed site ($site_name)"

