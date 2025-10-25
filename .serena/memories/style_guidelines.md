## Code Style & Conventions
- Home Assistant add-on manifests follow standard YAML formatting with double-quoted strings for user-facing text and schema definitions.
- Shell scripts under `rootfs/etc/my_init.d` use POSIX shell; keep scripts executable, rely on `/bin/sh` style syntax.
- Configuration defaults stored as YAML/INI; preserve indentation (2 spaces in YAML, key=value in ABCDE config).
- Documentation uses Markdown with GitHub-flavored conventions (heading levels, fenced code blocks, bold highlights).
- Follow Home Assistant add-on patterns: ingress enabled, options mirrored in schema, avoid introducing platform-specific characters (ASCII only).