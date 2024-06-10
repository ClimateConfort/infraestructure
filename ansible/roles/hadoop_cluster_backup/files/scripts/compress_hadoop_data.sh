#!/bin/bash
# Get the current date in YYYY-MM-DD format
DATE=$(date +\%Y-\%m-\%d)
# Define the source and destination directories
SRC_DIR="/root/hadoop-data"
DEST_DIR="/root"
# Define the compressed file name
COMPRESSED_FILE="hadoop-data-$DATE.tar.gz"
# Compress the directory
tar -czf $DEST_DIR/$COMPRESSED_FILE -C $SRC_DIR .

