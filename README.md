# ARM-HASS-Addon

![ARM Logo](arm/logo.png)

My attempt to get Automatic Ripping Machine running on Home Assistant with Intel QSV support.

**Note:** This addon is still in Alpha phase, **it's not functional yet**. You are welcome to participate into the developing of this add-on

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

## Development & CI/CD

### Container Image Build Optimization

The GitHub Actions workflow intelligently determines whether to rebuild the container image or retag an existing one:

**Image rebuild is triggered when:**
- `.docker/Dockerfile` is modified
- `arm/rootfs/run.sh` is modified
- Any file in `arm/rootfs/defaults/` is modified
- The `force_rebuild` input is checked when manually running the workflow

**Image retagging (no rebuild) occurs when:**
- Only non-image files are changed (e.g., documentation, configuration metadata)
- This saves build time and resources by reusing the existing multi-arch image

The workflow automatically:
1. Detects changes between the current and previous git tags
2. Rebuilds the image if any image-relevant files changed
3. Retags the existing image with new version labels if no relevant changes detected

This optimization reduces unnecessary builds while ensuring the image is always rebuilt when functional changes occur.

#### Manual Workflow Dispatch

The workflow can be triggered manually with a `force_rebuild` option:

1. Go to the **Actions** tab in GitHub
2. Select the **Build and Push Docker Image** workflow
3. Click **Run workflow**
4. Check the **Force a rebuild of the container image** option to bypass change detection and force a complete rebuild

This is useful for:
- Recovering from failed builds
- Rebuilding after upstream base image updates
- Testing the full build pipeline

#### Debug Logging

When GitHub Actions debug logging is enabled (by setting the `ACTIONS_STEP_DEBUG` repository secret to `true`), the workflow provides detailed information about:
- Which file patterns trigger rebuilds
- All files that changed in the current diff
- Which changed files matched the rebuild patterns
- The decision-making logic for rebuild vs. retag

**Note:** For manual workflow triggers (workflow_dispatch):
- When `force_rebuild` is **checked**: All change detection is bypassed and a full rebuild is performed
- When `force_rebuild` is **unchecked**: The workflow compares branch changes against the repository default branch (assumed `master`) and will retag the latest image if only non-image files changed

If your default branch is not `master`, adjust the workflow's `DEFAULT_BRANCH` variable accordingly (line 120 in `build-and-push.yml`).
