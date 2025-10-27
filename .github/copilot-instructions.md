# ARM-HASS-Addon — AI Guide

## Big Picture
- Home Assistant add-on wrapping the upstream `1337server/automatic-ripping-machine` image; repository provides add-on metadata plus overlay files under `arm/`.
- Deployment model: Pre-built multi-arch Docker images hosted on GitHub Container Registry (GHCR), pulled by Home Assistant instead of building locally.
- Startup flow: `arm/rootfs/run.sh` copies default configs from `/defaults/` to `/etc/arm/config/`, creates media directories, then launches ARM web UI with `exec python3 /opt/arm/arm/runui.py`.
- Configuration files: `arm/rootfs/defaults/arm.yaml`, `abcde.conf`, and `apprise.yaml` are copied to `/etc/arm/config/` on first run if not present.
- Privileged host access is required for optical drive (`/dev/sr0`, `/dev/sg0`) and Intel QSV (`/dev/dri/renderD128`); failures surface as warnings during init, so keep log messaging intact when editing scripts.

## Architecture & Distribution
- **CI/CD**: `.github/workflows/build-and-push.yml` automatically builds multi-arch images (amd64/arm64) when git tags matching `v*` are pushed
- **Image hosting**: ghcr.io/mliradelc/arm-hass-addon with tags: `latest`, `master`, `vX.Y.Z`, and semantic versions
- **Version management**: Version in `arm/config.yaml` must match git tag; both are used by GitHub Actions
- **Repository structure**: Proper HA add-on repository with `repository.yaml` at root, add-on in `arm/` subdirectory matching slug

## Conventions & Contracts
- Keep `arm/config.yaml` version synchronized with git tags for releases. Version format: `"X.Y.Z"` (quoted string).
- The startup script `arm/rootfs/run.sh` copies configs with `if [ ! -f ]` checks to preserve user modifications.
- Configuration files live in `/etc/arm/config/` at runtime (where ARM expects them), not in `/data/options.json` location.
- Critical ARM config: `WEBSERVER_IP: 0.0.0.0` (listen on all interfaces), `WEBSERVER_PORT: 8089` (internal port).
- Port mapping: `8089/tcp: 8089` in config.yaml keeps internal and external ports aligned.
- Watchdog URL format: `http://[HOST]:8089` - must use `[HOST]` placeholder and reference external port number.
- Bash scripts should use `set -e` for error handling; use `exec python3` for Python scripts to ensure proper process replacement.
- Documentation lives alongside code (`README.md`, `arm/DOCS.md`) and must reflect any option or path changes.

## Common Workflows
- **Version release**: Update version in `arm/config.yaml` → commit → create git tag `vX.Y.Z` → push tag → GitHub Actions builds and publishes images.
- **Testing locally**: Build with `docker build -f .docker/Dockerfile -t test-arm .` and run with `docker run -p 8089:8089 test-arm`.
- **Validate add-on**: In HA, reload add-on repository, update to new version, check logs for startup messages.
- When editing `run.sh`, maintain execute bit with `chmod +x arm/rootfs/run.sh` before committing.
- To verify image on GHCR: Check https://github.com/mliradelc/ARM-HASS-Addon/pkgs/container/arm-hass-addon

## Critical Configuration Points
- **Network binding**: ARM must bind to `0.0.0.0` for external access; set in `arm/rootfs/defaults/arm.yaml` as `WEBSERVER_IP: 0.0.0.0`.
- **Health check**: Watchdog format is strict - `http://[HOST]:EXTERNAL_PORT` where EXTERNAL_PORT matches the key in ports mapping.
- **Startup type**: Use `startup: application` (not `services`) for long-running web services that need health monitoring.
- **Python execution**: Always use `exec python3 /path/to/script.py` - never `exec /path/to/script.py` which treats .py as shell script.
- **Config file requirements**: ARM requires `arm.yaml`, `abcde.conf`, and `apprise.yaml` in `/etc/arm/config/` - all must be present or service fails.

## Integration Notes
- External port 8089 was chosen to avoid conflicts with common services using 8080.
- Port mapping in `arm/config.yaml` uses format `EXTERNAL/tcp: INTERNAL` - watchdog checks EXTERNAL, service listens on INTERNAL (both 8089 by default).
- Media directories are created by run.sh: `/media/ripped`, `/media/transcode`, `/media/raw`, `/media/music`.
- Home Assistant maps volumes as defined in `map:` section - `config:rw`, `share:rw`, `media:rw`.

## When Extending
- New configuration options should be added to `arm/config.yaml` schema and given defaults in the options section.
- New config files need entries in both `arm/rootfs/defaults/` and copy logic in `arm/rootfs/run.sh`.
- Before release: Update version in config.yaml, commit changes, create git tag, verify GitHub Actions build succeeds.
- Version numbering: Use semantic versioning (X.Y.Z) - increment PATCH for fixes, MINOR for features, MAJOR for breaking changes.
- All runtime issues should be logged with `[INFO]` or `[ERROR]` prefixes for user diagnostics.

## Known Issues & Solutions
- **Supervisor timeout**: Requires correct watchdog URL and `startup: application` setting.
- **Port not accessible**: Service must bind to `0.0.0.0`, not container's internal IP.
- **Missing config files**: Add to defaults directory and include copy logic in run.sh with proper error checking.
- **Watchdog validation errors**: Must match regex `^(?:https?|tcp):\/\/\[HOST\]:\d+.*$` - use exact format without `[PORT:]` syntax.
