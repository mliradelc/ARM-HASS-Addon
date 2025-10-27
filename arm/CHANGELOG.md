# Changelog

All notable changes to the ARM Home Assistant add-on are documented in this file. Release dates use the YYYY-MM-DD format.

## [0.2.0] - 2025-10-27

- **Added**: Enabled Home Assistant ingress so the ARM web UI can open inside the Supervisor sidebar.
- **Added**: Automatically provision raw, transcode, completed, log, and database directories based on the active `arm.yaml` values.
- **Fixed**: Prevent dashboard warnings about `/media/media/completed/` by creating the configured output paths on startup.
- **Documentation**: Updated add-on docs to mention ingress access and the automatic directory bootstrapping.

## [0.1.14] - 2025-10-26

- **Added**: Introduced a container health check that polls the ARM UI using `netcat-openbsd` before the Supervisor watchdog intervenes.
- **Fixed**: Corrected the port mapping to expose external port 8089 while ARM continues to listen on 8081 inside the container.

## [0.1.13] - 2025-10-26

- **Added**: Declared the `webui` metadata entry so Home Assistant shows a direct link to the ARM interface.
- **Changed**: Simplified environment handling by relying on Home Assistant metadata instead of redundant exports.

## [0.1.12] - 2025-10-26

- **Fixed**: Forced the ARM web server to bind to `0.0.0.0`, resolving connection issues for remote browsers, and improved startup logging to show the configured bind address.

## [0.1.11] - 2025-10-26

- **Added**: Migrated all configuration files to persistent storage under `/addon_configs/local_arm/` so edits survive container restarts.
- **Added**: Documented the new configuration workflow and updated helper scripts accordingly.
- **Breaking**: Users must migrate existing custom configurations from the previous ephemeral path to the new persistent location.

## [0.1.10] - 2025-10-26

- **Fixed**: Disabled the upstream image health check to avoid conflicts with the Home Assistant Supervisor watchdog.

## [0.1.9] - 2025-10-26

- **Fixed**: Ensured ARM listens on all interfaces and simplified the watchdog URL to the canonical external port.

## [0.1.8] - 2025-10-26

- **Fixed**: Updated the watchdog configuration to reference the correct port mapping placeholder syntax (`[PORT:8089]`).

## [0.1.7] - 2025-10-26

- **Fixed**: Adjusted the watchdog URL format to align with Supervisor validation rules.

## [0.1.6] - 2025-10-26

- **Fixed**: Pointed the watchdog to ARM's internal port 8081 to match the service binding.

## [0.1.5] - 2025-10-26

- **Changed**: Switched the exposed port from 8080 to 8089 to avoid collisions with common services.

## [0.1.4] - 2025-10-26

- **Added**: Added a Supervisor watchdog endpoint and set the startup type to `application` to keep the add-on alive during boots.

## [0.1.3] - 2025-10-26

- **Added**: Bundled a complete `apprise.yaml` to support all notification transports and copied it during startup.

## [0.1.2] - 2025-10-26

- **Fixed**: Updated `run.sh` to launch the ARM UI with `python3`, preventing shell execution errors.

## [0.1.1] - 2025-10-26

- **Fixed**: Cleaned up legacy configuration symlinks and improved repo structure following the Home Assistant add-on conventions.

## [0.1.0] - 2025-10-25

- **Added**: Initial beta release of the ARM add-on with multi-architecture images, default configuration files, and GitHub Actions automation.
