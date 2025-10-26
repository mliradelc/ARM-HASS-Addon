#!/bin/bash

set -e

echo "[INFO] Setting up ARM configuration..."

# Use /config for persistent storage (mapped via addon_config)
# This directory is accessible from the host at /addon_configs/local_arm/
CONFIG_DIR="/config"

# Ensure config directory exists
mkdir -p "${CONFIG_DIR}"

# Copy default ARM config if not present
if [ ! -f "${CONFIG_DIR}/arm.yaml" ]; then
  echo "[INFO] Copying default arm.yaml to ${CONFIG_DIR}"
  cp /defaults/arm.yaml "${CONFIG_DIR}/arm.yaml"
  chmod 644 "${CONFIG_DIR}/arm.yaml"
else
  echo "[INFO] Using existing arm.yaml from persistent storage"
fi

# Copy default abcde config if not present
if [ ! -f "${CONFIG_DIR}/abcde.conf" ]; then
  echo "[INFO] Copying default abcde.conf to ${CONFIG_DIR}"
  cp /defaults/abcde.conf "${CONFIG_DIR}/abcde.conf"
  chmod 644 "${CONFIG_DIR}/abcde.conf"
else
  echo "[INFO] Using existing abcde.conf from persistent storage"
fi

# Copy default apprise config if not present
if [ ! -f "${CONFIG_DIR}/apprise.yaml" ]; then
  echo "[INFO] Copying default apprise.yaml to ${CONFIG_DIR}"
  cp /defaults/apprise.yaml "${CONFIG_DIR}/apprise.yaml"
  chmod 644 "${CONFIG_DIR}/apprise.yaml"
else
  echo "[INFO] Using existing apprise.yaml from persistent storage"
fi

# Verify config files exist
if [ ! -f "${CONFIG_DIR}/arm.yaml" ]; then
  echo "[ERROR] Failed to create ${CONFIG_DIR}/arm.yaml"
  ls -la /defaults/
  ls -la "${CONFIG_DIR}"
  exit 1
fi

# Create symlink from ARM's expected location to our persistent config
# This ensures ARM finds the config regardless of where it looks
mkdir -p /etc/arm
if [ -L "/etc/arm/config" ] || [ -d "/etc/arm/config" ]; then
  rm -rf /etc/arm/config
fi
ln -s "${CONFIG_DIR}" /etc/arm/config
echo "[INFO] Created symlink: /etc/arm/config -> ${CONFIG_DIR}"

# Create media directories
mkdir -p /media/ripped /media/transcode /media/raw /media/music

# Verify and display config being used
echo "[INFO] Starting ARM web UI"
echo "[INFO] Config directory: ${CONFIG_DIR} (persistent)"
echo "[INFO] Config file: ${CONFIG_DIR}/arm.yaml"
echo "[INFO] Symlinked at: /etc/arm/config"

# Display the WEBSERVER_IP setting from config
WEBSERVER_IP_CONFIGURED=$(grep "^WEBSERVER_IP:" "${CONFIG_DIR}/arm.yaml" | awk '{print $2}')
echo "[INFO] WEBSERVER_IP configured as: ${WEBSERVER_IP_CONFIGURED}"

# Set environment variable to ensure ARM uses the config file location
export ARM_CONFIG="${CONFIG_DIR}/arm.yaml"

# Start ARM with explicit binding to 0.0.0.0 (all interfaces)
# Force the server to listen on all interfaces by setting environment variable
export WEBSERVER_IP="0.0.0.0"

echo "[INFO] Starting ARM with WEBSERVER_IP=${WEBSERVER_IP}"
exec python3 /opt/arm/arm/runui.py
