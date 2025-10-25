## Development & Verification Commands
- `ha addons reload` — refresh Home Assistant add-on repositories to pick up local changes (run from HA CLI when testing).
- `ha addons build arm` — build the add-on locally through the Home Assistant CLI when iterating on config or rootfs changes.
- `ha addons restart arm` — restart the ARM add-on after updates to ensure changes take effect.
- `docker build -t arm-addon-test arm` — optional local container build to validate Docker context before deploying to Home Assistant.

## macOS Utility Commands
- `ls`, `cat`, `grep`, `find` — inspect files within the repository.
- `chmod +x arm/rootfs/etc/my_init.d/*.sh` — ensure init scripts remain executable if modified.
- `python3 -m http.server` — quick local file serving for testing documentation rendering.