# ARM-HASS-Addon Project Overview

## Purpose
Home Assistant add-on that wraps the Automatic Ripping Machine (ARM) Docker image to provide automatic CD/DVD/Blu-ray ripping functionality within Home Assistant.

## Architecture
- **Base Image**: `1337server/automatic-ripping-machine`
- **Deployment**: GitHub Container Registry (GHCR) at `ghcr.io/mliradelc/arm-hass-addon`
- **Distribution**: Custom Home Assistant add-on repository via the repository URL.
- **Multi-arch Support**: amd64 and arm64 (aarch64)

## Key Components
1. **Add-on Configuration** (`arm/config.yaml`): Defines add-on metadata, ports, privileges, and ingress support.
2. **Startup Script** (`arm/rootfs/run.sh`): Initializes configuration files and starts the ARM web UI.
3. **Default Configs** (`arm/rootfs/defaults/`): Contains `arm.yaml`, `abcde.conf`, and `apprise.yaml` templates.
4. **CI/CD** (`.github/workflows/build-and-push.yml`): Automated multi-arch builds triggered by git tags.

## Installation
Users add the repository URL to Home Assistant, then install the ARM add-on from the add-on store. Updates are delivered via new version tags that trigger automated builds.

## Hardware & Privileges
- The add-on now uses `full_access: true` along with `device_tree`, `udev`, `kernel_modules`, and specific `privileged` capabilities (`SYS_ADMIN`, `DAC_READ_SEARCH`, `NET_ADMIN`, `SYS_RAWIO`) to access host hardware like optical drives and for features like Intel QuickSync. This replaces the explicit `devices` list.

## Web Interface & Ingress
- **Internal Port**: 8089 (where ARM listens)
- **External Port**: 8089 (exposed to Home Assistant host)
- **Access**: `http://[HOME_ASSISTANT_IP]:8089`
- **Ingress**: The add-on now supports Ingress, allowing seamless access from the Home Assistant UI sidebar.

## Current Status (v0.2.6)
- The add-on is marked as `experimental`.
- Working automated builds via GitHub Actions.
- Multi-arch images are published to GHCR.
- Health checks and network binding are correctly configured.
- All required config files (`arm.yaml`, `abcde.conf`, `apprise.yaml`) are included.
- Added a direct link to the GitHub repository in the add-on configuration.
