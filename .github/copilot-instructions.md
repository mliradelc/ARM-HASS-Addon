# ARM-HASS-Addon — AI Guide

## Big Picture
- Home Assistant add-on wrapping the upstream `1337server/automatic-ripping-machine` image; repository only provides add-on metadata plus overlay files under `arm/`.
- Startup flow: Supervisor injects `options.json` → `arm/rootfs/etc/my_init.d/05_arm_setup.sh` reads options with `jq`, prepares directories/permissions, patches `/etc/arm/config/arm.yaml`, then the base image launches ARM.
- `arm/rootfs/defaults/arm.yaml` and `abcde.conf` seed runtime config; the init script rewrites specific keys (paths, HandBrake presets) each boot.
- Privileged host access is required for optical drive (`/dev/sr0`, `/dev/sg0`) and Intel QSV (`/dev/dri/renderD128`); failures surface as warnings during init, so keep log messaging intact when editing scripts.

## Conventions & Contracts
- Keep `arm/config.yaml` options, schema, and defaults synchronized with the fallbacks in `05_arm_setup.sh` and the documentation. A mismatch (e.g., current `media_staging` default `/data/arm/staging` vs script fallback `/media/ripped`) becomes a user-facing bug.
- The init script’s `sed -i "^KEY:"` replacements assume top-level keys in `arm.yaml` start at column 1 and use uppercase identifiers; do not reformat `defaults/arm.yaml` without updating the sed patterns.
- Bash scripts should remain POSIX-friendly with `set -euo pipefail`; rely on `jq`/`sed` instead of bashio helpers (removed in 2.6.15).
- Documentation lives alongside code (`README.md`, `INSTALL_IN_HA.md`, `arm/DOCS.md`) and must reflect any option or path changes—update all three when altering behavior.

## Common Workflows
- Validate add-on schema changes inside Home Assistant: `ha addons reload` → `ha addons build arm` (if using local dev environment) → `ha addons restart arm` and tail logs for the init script output.
- When editing init scripts, reapply execute bit (`chmod +x arm/rootfs/etc/my_init.d/05_arm_setup.sh`) before packaging; Supervisor strips it if committed incorrectly.
- To sanity-check runtime config generation without HA, run the container locally with `docker run --rm -v "$(pwd)/test-options.json:/data/options.json" -v "$(pwd)/arm/rootfs:/rootfs" 1337server/automatic-ripping-machine:latest /rootfs/etc/my_init.d/05_arm_setup.sh` (simulate options parsing before full build).

## Integration Notes
- QSV enablement flips HandBrake presets (`HB_PRESET_DVD`/`HB_PRESET_BD`) and adds the `arm` user to the render group; if you add transcoding options, update both branches of the conditional.
- `media_staging` is currently only created/chowned; if you intend the add-on to use it as the final drop location, extend the sed patch or adjust defaults accordingly.
- The syslog-ng stub (`10_syslog-ng.init`) prevents the base image from touching read-only `/dev`; keep it lightweight to avoid restart loops.

## When Extending
- New configuration knobs should be added to `arm/config.yaml`, surfaced in docs, given sane defaults in the init script, and, if they influence ARM config, patched into `defaults/arm.yaml` via explicit `sed` rules.
- Before release, update `arm/CHANGELOG.md` and verify optical drive + QSV detection messaging, since users rely on those log lines for support diagnostics.
