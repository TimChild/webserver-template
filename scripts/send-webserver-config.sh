#!/bin/bash
# Sends the configuration files required by the webserver (does NOT send all the files that 
# may need to be served by the webserver)
# Used both in initial setup and when updating the configuration
#
# Args:
# - ssh_name: ssh alias for the server
#

function heading() {
    echo "-------"
    printf "\033[1;32m %s \033[0m \n" "$1"
    echo "-------"
}

set -e

ssh_name=$1

if [ -z "$ssh_name" ]; then
    echo "Usage: send-webserver-config.sh <ssh_name>"
    exit 1
fi

heading "Sending webserver config to droplet ($ssh_name)"

scp {caddy-compose.yaml,Caddyfile} $ssh_name:~/

# Update the `sites-enabled` directory (removes any that are no longer in local directory)
rsync -avL --delete ./sites-enabled/ $ssh_name:~/sites-enabled/


