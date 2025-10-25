#!/bin/bash

set -e

echo "[INFO] Setting up ARM configuration..."

# Clean up any old symlinks/files from previous installations
if [ -L "/share/arm_config/config" ] || [ -e "/share/arm_config/config" ]; then
  echo "[INFO] Removing old config symlink/file"
  rm -rf /share/arm_config/config
fi

# Create ARM config directory
mkdir -p /etc/arm/config

# Copy default ARM config if not present
if [ ! -f "/etc/arm/config/arm.yaml" ]; then
  echo "[INFO] Copying default arm.yaml to /etc/arm/config"
  cp /defaults/arm.yaml /etc/arm/config/arm.yaml
  chmod 644 /etc/arm/config/arm.yaml
else
  echo "[INFO] Using existing arm.yaml"
fi

# Copy default abcde config if not present
if [ ! -f "/etc/arm/config/abcde.conf" ]; then
  echo "[INFO] Copying default abcde.conf to /etc/arm/config"
  cp /defaults/abcde.conf /etc/arm/config/abcde.conf
  chmod 644 /etc/arm/config/abcde.conf
else
  echo "[INFO] Using existing abcde.conf"
fi

# Verify config files exist
if [ ! -f "/etc/arm/config/arm.yaml" ]; then
  echo "[ERROR] Failed to create /etc/arm/config/arm.yaml"
  ls -la /defaults/
  ls -la /etc/arm/config/
  exit 1
fi

# Create media directories
mkdir -p /media/ripped /media/transcode /media/raw /media/music

# Start armui
echo "[INFO] Starting ARM web UI"
echo "[INFO] Config file: /etc/arm/config/arm.yaml"
exec /opt/arm/arm/runui.py
