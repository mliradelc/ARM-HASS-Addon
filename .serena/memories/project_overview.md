# ARM-HASS-Addon Project Overview

## Purpose
Home Assistant add-on that wraps the Automatic Ripping Machine (ARM) Docker image to provide automatic CD/DVD/Blu-ray ripping functionality within Home Assistant.

## Architecture
- **Base Image**: `1337server/automatic-ripping-machine:latest` from Docker Hub
- **Deployment**: GitHub Container Registry (GHCR) at `ghcr.io/mliradelc/arm-hass-addon`
- **Distribution**: Custom Home Assistant add-on repository
- **Multi-arch Support**: amd64 and arm64 (aarch64)

## Key Components
1. **Add-on Configuration** (`arm/config.yaml`): Defines add-on metadata, ports, devices, privileges
2. **Startup Script** (`arm/rootfs/run.sh`): Initializes configuration files and starts ARM web UI
3. **Default Configs** (`arm/rootfs/defaults/`): Contains arm.yaml, abcde.conf, apprise.yaml templates
4. **Docker Build** (`.docker/Dockerfile`): Custom image that installs HandBrake and copies overlay files
5. **CI/CD** (`.github/workflows/build-and-push.yml`): Automated multi-arch builds triggered by git tags

## Installation
Users add the repository URL to Home Assistant, then install the ARM add-on from the add-on store. Updates are delivered via new version tags that trigger automated builds.

## Hardware Requirements
- Optical drive access: `/dev/sr0`, `/dev/sg0`
- Intel QuickSync support: `/dev/dri/renderD128`
- Privileged access for hardware control

## Web Interface
- Internal Port: 8089 (where ARM listens)
- External Port: 8089 (exposed to Home Assistant host)
- Access: `http://[HOME_ASSISTANT_IP]:8089`

## Current Status (v0.1.9)
- Working automated builds via GitHub Actions
- Multi-arch images published to GHCR
- Proper health checks and network binding configured
- All required config files (arm.yaml, abcde.conf, apprise.yaml) included
