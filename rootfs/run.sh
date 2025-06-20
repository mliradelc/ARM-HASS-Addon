#!/bin/bash

set -e

# Create folders
mkdir -p /media/arm
mkdir -p /media/arm/transcode
mkdir -p /media/arm/raw
mkdir -p /media/music
mkdir -p /media/media
mkdir -p /media/arm/config

# Copy default ARM config if not present
if [ ! -f "/media/arm/config/config/arm.yaml" ]; then
  echo "[INFO] Copying default arm.yaml to /media/arm/config"
  cp /defaults/arm.yaml /media/arm/config
fi

# Copy default ARM Music config if not present
if [ ! -f "/media/arm/config/config/abcde.conf" ]; then
  echo "[INFO] Copying default abcde.conf to /media/arm/config"
  cp /defaults/abcde.conf /media/arm/config
fi

# Start armui
echo "Starting web ui"
chmod +x /opt/arm/arm/runui.py
exec /sbin/setuser arm /bin/python3 /opt/arm/arm/runui.py
