#!/bin/bash
# Get the current date in YYYY-MM-DD format
DATE=$(date +\%Y-\%m-\%d)
# Define the compressed file name
COMPRESSED_FILE="/root/hadoop-data-$DATE.tar.gz"
# Define the destination directory on the remote host
REMOTE_DIR="/home/user/backups/hadoop"
# Define the remote host and user
REMOTE_HOST="10.0.2.15"
REMOTE_USER="user"
# Define the path to the SSH key 
SSH_KEY="~/.ssh/backup"
# Copy the compressed file to the remote host
scp -i $SSH_KEY $COMPRESSED_FILE $REMOTE_USER@$REMOTE_HOST:$REMOTE_DIR

