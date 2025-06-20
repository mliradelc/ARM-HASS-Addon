# ARM-HASS-Addon
My attempt to get Automatic Ripping Machine running on Home Assistant OS Supervised with Intel QSV support.

## Goal:
- Get ARM running via a addon to backup bluerays, dvd's and cd's to media folder.
- Leverage intel quicksync for media transcoding.

## Progress:
- So far the addon installs the docker image `1337server/automatic-ripping-machine` as it comes with the `install-handbrake.sh` script that enables QSV support. So that gets run at addon install so it takes a while (and a lot of cpu) for the addon to install.
- The addon itself also copies the config files in `defaults` to `/etc/arm/config` in the container. The configs have the media output paths set to `/media/music/` and `/media/media/completed/`.
- All other related folders like `transcode` or `raw` are located in `/media/arm/` to allow for easier cleanup for the time being. May change in the future when its proven to actually work.

## Install:
I don't reccomend installing as the addon is still very much in testing and will likely change a lot but if you want to test yourself:
- Download github repo.
- Put addon root folder into /addons (use SAMBA addon to access).
- Check addon store for updates and refresh page.
- Click install and wait a while.
- Access Via web ui on port 8081.
