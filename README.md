# ARM-HASS-Addon
My attempt to get Automatic Ripping Machine running on Home Assistant OS Supervised with Intel QSV support.

## Goal:
- Get ARM running via a addon to backup bluerays, dvd's and cd's to media folder.
- Leverage intel quicksync for media transcoding.

## Progress:
- So far the addon installs the docker image `1337server/automatic-ripping-machine` as it comes with the `install-handbrake.sh` script that enables QSV support. So that gets run at addon install so it takes a while (and a lot of cpu) for the addon to install.
- The addon uses persistent storage via Home Assistant's `addon_config` mapping, which stores configuration at `/addon_configs/local_arm/` on the host and mounts it at `/config` in the container.
- ARM configuration files (`arm.yaml`, `abcde.conf`, `apprise.yaml`) are stored persistently and survive container restarts.
- Configuration files can be edited directly from Home Assistant using the File Editor addon or via Samba/SSH.
- The configs have the media output paths set to `/media/music/` and `/media/media/completed/`.
- All other related folders like `transcode` or `raw` are located in `/media/arm/` to allow for easier cleanup for the time being. May change in the future when its proven to actually work.

## Configuration:
- Configuration files are stored persistently at `/addon_configs/local_arm/` on the host
- You can edit these files using:
  - Home Assistant File Editor addon
  - Samba share (if Samba addon is installed)
  - SSH (if SSH addon is installed)
- After editing configuration, restart the ARM addon for changes to take effect

## Install:
I don't reccomend installing as the addon is still very much in testing and will likely change a lot but if you want to test yourself:
- Download github repo.
- Put addon root folder into /addons (use SAMBA addon to access).
- Check addon store for updates and refresh page.
- Click install and wait a while.
- Access via web UI on port 8089 (external port mapped to internal 8081).
- Configuration files are automatically created on first run and stored persistently.
