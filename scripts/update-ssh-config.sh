#!/bin/bash
# Updates local ~/.ssh/config to include a new ssh alias for DO droplet
# Args:
# - droplet_name: name of the droplet (e.g., webserver) -- will be used as the ssh alias
# - [user]: username to use for ssh (default: webadmin)

set -e

droplet_name=$1
user=${2:-webadmin}

if [ -z "$droplet_name" ]; then
    echo "Usage: update-ssh-config.sh <droplet_name> [user]"
    exit 1
fi

cat <<EOF >> ~/.ssh/config
Host $droplet_name
  HostName $(doctl compute droplet get $droplet_name --format PublicIPv4 --no-header)
  User $user
  IdentityFile ~/.ssh/id_ed25519

EOF

