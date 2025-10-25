#!/bin/bash

set -e

# Create folders
mkdir -p /media/arm /media/arm/transcode /media/arm/raw /media/music /media/media /media/arm/config

# Symlink /etc/arm/config to media folder
rm -rf /etc/arm/config
ln -s /media/arm/config /share/arm_config

# Copy default ARM config if not present
if [ ! -f "/media/arm/config/config/arm.yaml" ]; then
  echo "[INFO] Copying default arm.yaml to /etc/arm_config"
  cp /defaults/arm.yaml /media/arm/config
fi

# Copy default ARM Music config if not present
if [ ! -f "/media/arm/config/config/abcde.conf" ]; then
  echo "[INFO] Copying default abcde.conf to /share/arm_config"
  cp /defaults/abcde.conf /share/arm_config
fi

# Start armui
echo "Starting web ui"
chmod +x /opt/arm/arm/runui.py
exec /sbin/setuser arm /bin/python3 /opt/arm/arm/runui.py
