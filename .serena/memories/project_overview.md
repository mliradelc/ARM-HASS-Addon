## Project Purpose
Home Assistant add-on that packages the Automatic Ripping Machine (ARM) with Intel QuickSync support so optical discs inserted into a Home Assistant host are automatically ripped, transcoded, and stored.

## Tech Stack
- Home Assistant add-on manifest and schema in YAML (`arm/config.yaml`).
- Container filesystem overrides and init scripts under `arm/rootfs` (shell scripting).
- Documentation in Markdown (`README.md`, `DOCS.md`, `INSTALL_IN_HA.md`).
- Uses upstream Docker image `1337server/automatic-ripping-machine` for ARM, MakeMKV, HandBrake.

## Repo Structure
- `arm/`: add-on definition (config, docs, changelog, licensing, rootfs defaults/init scripts).
- `arm/rootfs/defaults`: default config files (`arm.yaml`, `abcde.conf`).
- `arm/rootfs/etc/my_init.d`: startup scripts configuring ARM environment.
- Root docs for installation and overview.

## Notable Integrations
- Exposes ingress web UI on port 8686 for ARM dashboard.
- Maps Home Assistant storage (`share`, `media`) plus optical drive and Intel GPU devices.
- Options allow configuring output directories, UID/GID, timezone, and toggling Intel QSV.