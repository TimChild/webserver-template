#!/bin/bash
# Initialize a new site with a backend on the webserver (script runs locally)
# Args:
# - ssh_name: ssh alias for the server
# - site_name: name of the site to create
# - domain: domain to use for the site
# - backend-image: name of the backend image to use
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
backend_image=$3
domain=$4

_backend_service_name="${site_name}-backend"

if [ -z "$ssh_name" ] || [ -z "$site_name" ] || [ -z "$backend_image" ]; then
    echo "Usage: webserver-init-new-backend-site.sh <ssh_name> <site_name> <backend_image> [domain]"
    exit 1
fi

heading "Initializing new backend site ($site_name) on ($ssh_name) with backend image ($backend_image) and domain ($domain)"

# Check that the site does not already exist on the webserver (where it is actually served)
if ssh $ssh_name "[ -d /srv/www/$site_name ]"; then
    warning "Site $site_name already exists on the webserver"
    exit 1
fi

if [ -z "$domain" ]; then
    echo "No domain provided. No Caddy config will be created"
else
    echo "Creating caddy config locally..."
    DOMAIN=$domain SITE_NAME=$site_name BACKEND_SERVICE=$_backend_service_name \
        envsubst < caddyfile-templates/template-reflex.caddy > sites-enabled/$site_name.caddy
    echo "Sending config to webserver..."
    scp sites-enabled/$site_name.caddy $ssh_name:~/sites-enabled/
fi

echo "Adding a backend service to the docker-compose file..."
cat <<EOF >> caddy-compose.yaml
  $_backend_service_name:
    image: $backend_image
    container_name: $_backend_service_name
    restart: unless-stopped
    env_file: "sites/$site_name/.env"

EOF

echo "Creating directories on the webserver..."
ssh $ssh_name "rm -rf ~/sites/$site_name && mkdir -p ~/sites/$site_name/static"
ssh $ssh_name "sudo mkdir -p /srv/www/$site_name"

heading "New static site initialized successfully"

echo "Note that site won't be visible until deploy task is run"
# Deploy task will sync the config (.caddy) as well as static files
