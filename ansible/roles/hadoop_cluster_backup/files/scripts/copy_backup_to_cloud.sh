#!/bin/bash
# Get the current date in YYYY-MM-DD format
DATE=$(date +\%Y-\%m-\%d)
# Define the compressed file name
COMPRESSED_FILE="/root/hadoop-data-$DATE.tar.gz"
# Define the destination directory on the cloud machine
# CLOUD_DIR="/etc/backups/hadoop/"
CLOUD_DIR="/home/user"

# Define the cloud machine details
CLOUD_HOST="34.70.52.159"
CLOUD_USER="user"
# Define the path to the SSH key
SSH_KEY="~/.ssh/backup"
# Copy the compressed file to the cloud machine
scp -i $SSH_KEY $COMPRESSED_FILE $CLOUD_USER@$CLOUD_HOST:$CLOUD_DIR

