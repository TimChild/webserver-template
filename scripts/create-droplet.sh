#!/bin/bash
# This script creates a new droplet on DigitalOcean (no extra setup other than providing the
# ssk key id and project id during creation)
# Adds convenience of being able to provide ssh-key and project name rather than ids.
#
# Args:
# - name: Name of the droplet
# - size: Size of the droplet (e.g. s-1vcpu-1gb)
# - image: Image to use for the droplet (e.g. ubuntu-20-04-x64)
# - region: Region to create the droplet in (e.g. nyc1)
# - ssh_key_name: Name of the ssh key (stored in DO) to add to the droplet on creation
# - project_name: Name of the project to create the droplet in


# Exit on error
set -e 

function heading() {
    echo "-------"
    printf "\033[1;32m %s \033[0m \n" "$1"
    echo "-------"
}

heading "Creating droplet"

# Extract arguments
name="$1"
size="$2"
image="$3"
region="$4"
ssh_key_name="$5"
project_name="$6"

echo "Name: $name"
echo "Size: $size"
echo "Image: $image"
echo "Region: $region"
echo "SSH Key Name: $ssh_key_name"
echo "Project Name: $project_name"

# Check all arguments are provided
if [ -z "$name" ] || [ -z "$size" ] || [ -z "$image" ] || [ -z "$region" ] || [ -z "$ssh_key_name" ] || [ -z "$project_name" ]; then
  echo "Usage: create_droplet.sh <name> <size> <image> <region> <ssh_key_name> <project_name>"
  exit 1
fi

# Determine SSH key id by name
ssh_key_id=$(doctl compute ssh-key list | grep -w $ssh_key_name | awk '{print $1}')

# Determine project id by name
project_id=$(doctl projects list | grep -w "$project_name" | awk '{print $1}')

echo "creating droplet..."

doctl compute droplet create "$name"\
    --size "$size"\
    --image "$image"\
    --region "$region"\
    --ssh-keys "$ssh_key_id"\
    --project-id "$project_id"\
    --enable-monitoring\
    --wait

heading "Droplet created successfully"
