#!/bin/bash
# Initialize a new static site on the webserver (runs locally)
# Args:
# - ssh_name: ssh alias for the server
# - site_name: name of the site to create
# 
# What this script does:
# - Create new directories in the ~/sites and /srv/www
# - does NOT restart caddy since this does not imply sending the new static site files yet


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

ssh_name=$1
site_name=$2


if [ -z "$ssh_name" ] || [ -z "$site_name" ]; then
    echo "Usage: webserver-init-new-static-site.sh <ssh_name> <site_name>"
    exit 1
fi

heading "Initializing new static site ($site_name) on ($ssh_name)"

# Check that the site does not already exist on the webserver
if ssh $ssh_name "[ -d /srv/www/$site_name ]"; then
    warning "Site $site_name already exists on the webserver"
    exit 1
fi

echo "Creating directories on the webserver..."
# Create directories on the webserver
ssh $ssh_name "rm -rf ~/sites/$site_name && mkdir -p ~/sites/$site_name/static"
ssh $ssh_name "sudo mkdir -p /srv/www/$site_name"

heading "Static site initialized successfully"
echo "Note that site won't be visible until deploy task is run"
# Deploy task will sync the config (.caddy) as well as static files


