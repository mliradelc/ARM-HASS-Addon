# ARM (Automatic Ripping Machine) Add-on

![ARM Logo](logo.png)

Automatically rip and transcode optical media (DVDs, Blu-rays, CDs) with Intel Quick Sync Video (QSV) support.

## About

This add-on wraps the `1337server/automatic-ripping-machine` Docker image and provides:

- Automatic detection and ripping of optical media
- Hardware-accelerated transcoding with Intel QSV
- Web UI for monitoring ripping jobs
- Persistent configuration storage

## Installation

1. Add this repository to your Home Assistant add-on store.
2. Install the ARM add-on (first install takes longer as it compiles HandBrake with QSV support).
3. Configure device access for your optical drive.
4. Start the add-on.
5. Access the web UI on port 8089.

## Configuration

### Persistent Storage

Configuration files are stored persistently at `/addon_configs/local_arm/` on the host and are accessible via:

- **File Editor addon**: Navigate to `/addon_configs/local_arm/`.
- **Samba share**: Access the `addon_configs/local_arm/` folder.
- **SSH**: Files located at `/addon_configs/local_arm/`.

The following configuration files are created automatically on first run:

- `arm.yaml` — Main ARM configuration.
- `abcde.conf` — Audio CD ripping configuration.
- `apprise.yaml` — Notification configuration.

### Configuration Files

#### arm.yaml

The main ARM configuration file controls ripping behavior, transcoding settings, and output paths. Key settings include:

- `WEBSERVER_IP` and `WEBSERVER_PORT` — Web UI access (default: 0.0.0.0:8089).
- `RIPMETHOD` — Ripping method (mkv, backup, etc.).
- `TRANSCODE_PATH`, `COMPLETED_PATH` — Output directories.
- `HW_DECODE` and `HW_ENCODE` — Hardware acceleration settings.

Default paths (created automatically on startup):

- Completed media: `/media/media/completed/`.
- Music: `/media/music/`.
- Transcode/temporary: `/media/arm/`.

#### abcde.conf

Configuration for audio CD ripping with abcde.

#### apprise.yaml

Notification configuration for ARM events (rip started, completed, errors).

### Editing Configuration

After editing any configuration file:

1. Save your changes.
2. Restart the ARM add-on from the Home Assistant UI.
3. Changes will take effect on next run.

## Hardware Requirements

### Optical Drive

- A DVD/Blu-ray optical drive accessible at `/dev/sr0`.
- SCSI generic device at `/dev/sg0` (for certain operations).

### Intel Quick Sync Video (QSV)

- Intel CPU with integrated graphics (6th gen or newer recommended).
- Intel GPU device at `/dev/dri/renderD128`.

The add-on will start without QSV hardware, but transcoding will fall back to CPU encoding.

## Volume Mappings

The add-on uses the following volume mappings:

- `/config` — Persistent add-on configuration (ARM config files).
- `/share` — Home Assistant shared storage.
- `/media` — Media library storage (for ripped content).

## Usage

1. Insert a disc into your optical drive.
2. ARM will automatically detect the disc and begin ripping.
3. Monitor progress via the web UI at port 8089.
4. Completed media will be saved to the configured output path.
5. The disc will be ejected when complete.

## Web UI

Open the ARM interface via the Home Assistant add-on ingress (Add-on → ARM → Open Web UI) or directly at `http://homeassistant.local:8089`.

The web UI provides:

- Active ripping job status.
- Job history.
- Configuration overview.
- Manual job triggering.

## Troubleshooting

### Configuration Not Taking Effect

- Ensure configuration files are saved.
- Restart the add-on after making changes.
- Check add-on logs for configuration errors.

### Disc Not Detected

- Verify optical drive is connected and accessible.
- Check that `/dev/sr0` is available on the host.
- Ensure proper device permissions in add-on configuration.

### QSV Not Working

- Verify Intel integrated graphics is enabled in BIOS.
- Check that `/dev/dri/renderD128` exists on the host.
- Review add-on logs for hardware initialization messages.

### Check Configuration Location

From within the container (via SSH or exec):

```bash
# View current config
cat /config/arm.yaml

# Check symlink
ls -la /etc/arm/config

# Verify files
find /config -type f
```

## Support

For issues and questions:

- Check add-on logs in Home Assistant.
- Review the [ARM documentation](https://github.com/automatic-ripping-machine/automatic-ripping-machine).
- Open an issue on the add-on repository.

## Version History

### 0.1.11

- **Breaking Change**: Switched to persistent configuration storage using `addon_config`.
- Configuration files now stored at `/addon_configs/local_arm/` (accessible from host).
- Config files survive container restarts.
- Users can edit configuration files via File Editor, Samba, or SSH.
- Improved logging to show config file locations.

### 0.1.10

- Previous versions (see git history).
