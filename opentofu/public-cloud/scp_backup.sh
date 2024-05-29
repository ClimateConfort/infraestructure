#!/bin/bash

# Variables
INSTANCE_NAME="node1" # replace with your instance name
INSTANCE_ZONE="us-central1-a" # replace with your instance zone
SOURCE_DIR="/etc/cassandra"
DEST_USER="user"
SSH_KEY="../../credentials/ssh-keys/key" # path to your SSH private key, adjust if necessary

# Fetch the external IP address using gcloud
DEST_HOST=$(gcloud compute instances describe $INSTANCE_NAME --zone $INSTANCE_ZONE --format='get(networkInterfaces[0].accessConfigs[0].natIP)')

if [ -z "$DEST_HOST" ]; then
    echo "Error: Could not find the instance with name $INSTANCE_NAME in zone $INSTANCE_ZONE"
    exit 1
fi

DEST_DIR="../../ansible/roles/config-file-copy/files"

# Create destination directory if it doesn't exist
mkdir -p $DEST_DIR

# SCP command to copy directory from remote to local
scp -i $SSH_KEY -r $DEST_USER@$DEST_HOST:$SOURCE_DIR $DEST_DIR
