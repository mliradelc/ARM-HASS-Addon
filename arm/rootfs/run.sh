#!/bin/bash

set -e

# Create ARM config directory
mkdir -p /etc/arm/config

# Copy default ARM config if not present
if [ ! -f "/etc/arm/config/arm.yaml" ]; then
  echo "[INFO] Copying default arm.yaml to /etc/arm/config"
  cp /defaults/arm.yaml /etc/arm/config/arm.yaml
fi

# Copy default abcde config if not present
if [ ! -f "/etc/arm/config/abcde.conf" ]; then
  echo "[INFO] Copying default abcde.conf to /etc/arm/config"
  cp /defaults/abcde.conf /etc/arm/config/abcde.conf
fi

# Create media directories
mkdir -p /media/ripped /media/transcode /media/raw /media/music

# Start armui
echo "Starting ARM web UI"
exec /opt/arm/arm/runui.py
