#!/bin/bash

set -e

echo "[INFO] Setting up ARM configuration..."

# Use /config for persistent storage (mapped via addon_config)
# This directory is accessible from the host at /addon_configs/local_arm/
CONFIG_DIR="/config"

# Ensure config directory exists
mkdir -p "${CONFIG_DIR}"

read_config_value() {
  local key="$1"
  local line value
  line=$(grep -E "^${key}:" "${CONFIG_DIR}/arm.yaml" || true)
  if [ -z "${line}" ]; then
    return
  fi
  value="${line#*:}"
  value="${value%%#*}"
  value="$(echo "${value}" | awk '{$1=$1;print}')"
  value="${value#\"}"
  value="${value%\"}"
  echo "${value}"
}

ensure_directory() {
  local path="$1"
  if [ -z "${path}" ]; then
    return
  fi
  mkdir -p "${path}"
  echo "[INFO] Ensured path exists: ${path}"
}

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

# Ensure directories defined in config exist
RAW_PATH=$(read_config_value "RAW_PATH")
TRANSCODE_PATH=$(read_config_value "TRANSCODE_PATH")
COMPLETED_PATH=$(read_config_value "COMPLETED_PATH")
LOGPATH=$(read_config_value "LOGPATH")
DBFILE=$(read_config_value "DBFILE")

ensure_directory "${RAW_PATH}"
ensure_directory "${TRANSCODE_PATH}"
ensure_directory "${COMPLETED_PATH}"
ensure_directory "${LOGPATH}"

if [ -n "${DBFILE}" ]; then
  ensure_directory "$(dirname "${DBFILE}")"
fi

# Verify and display config being used
echo "[INFO] Starting ARM web UI with ingress support"
echo "[INFO] Config directory: ${CONFIG_DIR} (persistent)"
echo "[INFO] Config file: ${CONFIG_DIR}/arm.yaml"
echo "[INFO] Symlinked at: /etc/arm/config"

# Display the WEBSERVER_IP setting from config
WEBSERVER_IP_CONFIGURED=$(grep "^WEBSERVER_IP:" "${CONFIG_DIR}/arm.yaml" | awk '{print $2}')
echo "[INFO] WEBSERVER_IP configured as: ${WEBSERVER_IP_CONFIGURED}"

# Set environment variable to ensure ARM uses the config file location
export ARM_CONFIG="${CONFIG_DIR}/arm.yaml"

# Configure ARM to run on internal port 8090
# Nginx will proxy from port 8089 (ingress) to 8090 (ARM)
export WEBSERVER_IP="0.0.0.0"
export WEBSERVER_PORT="8090"

echo "[INFO] Starting nginx reverse proxy for ingress support..."
echo "[INFO] Nginx listening on port 8089 (ingress)"
echo "[INFO] ARM listening on port 8090 (internal)"

# Start nginx in the background
nginx -g 'daemon off;' &
NGINX_PID=$!
echo "[INFO] Nginx started with PID ${NGINX_PID}"

# Give nginx a moment to start
sleep 2

# Function to handle shutdown
shutdown_handler() {
    echo "[INFO] Shutting down services..."
    kill -TERM "$ARM_PID" 2>/dev/null
    kill -TERM "$NGINX_PID" 2>/dev/null
    wait
    exit 0
}

# Trap termination signals
trap shutdown_handler SIGTERM SIGINT

# Start ARM web UI in background
echo "[INFO] Starting ARM with WEBSERVER_IP=${WEBSERVER_IP} WEBSERVER_PORT=${WEBSERVER_PORT}"
python3 /opt/arm/arm/runui.py &
ARM_PID=$!
echo "[INFO] ARM started with PID ${ARM_PID}"

# Wait for ARM process (main service)
wait "$ARM_PID"
