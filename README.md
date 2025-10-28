# ARM-HASS-Addon

![ARM Logo](arm/logo.png)

My attempt to get Automatic Ripping Machine running on Home Assistant OS Supervised with Intel QSV support.

## Goal

- Get ARM running via an add-on to back up Blu-rays, DVDs, and CDs to the media folder.
- Leverage Intel Quick Sync for media transcoding.

## Progress

- The add-on installs the Docker image `1337server/automatic-ripping-machine` because it includes the `install-handbrake.sh` script that enables QSV support, so the first install takes a while (and plenty of CPU).
- The add-on uses persistent storage via Home Assistant's `addon_config` mapping, storing configuration at `/addon_configs/local_arm/` on the host and mounting it at `/config` in the container.
- ARM configuration files (`arm.yaml`, `abcde.conf`, `apprise.yaml`) are stored persistently and survive container restarts.
- Configuration files can be edited directly from Home Assistant using the File Editor add-on or via Samba/SSH.
- The configs set media output paths to `/media/music/` and `/media/media/completed/`.
- Related folders like `transcode` and `raw` live in `/media/arm/` to simplify cleanup for now.

## Configuration

- Configuration files are stored persistently at `/addon_configs/<ID>_arm/` on the host.
- You can edit these files using:
  - Home Assistant File Editor add-on
  - Samba share (if the Samba add-on is installed)
  - SSH (if the SSH add-on is installed)
- After editing configuration, restart the ARM add-on for changes to take effect.

Is also possible to edit configs directly inside ARM user interface, which will save them to the persistent storage.

## Install

Add this repository URL to the Home Assistant add-on store (Settings → Add-ons → Add-on Store → ⁝ → Repositories), then install the “ARM” add-on from the list. The add-on listens on port 8089 and creates its configuration files on first run.
