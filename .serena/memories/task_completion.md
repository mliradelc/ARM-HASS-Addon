## Task Completion Checklist
- Validate YAML syntax in `arm/config.yaml` and other manifests (`yamllint` or Home Assistant config check) after edits.
- Ensure shell scripts in `rootfs/etc/my_init.d` remain executable and shellcheck-clean when possible.
- If options/schema change, confirm the schema matches defaults and update documentation (`README.md`, `DOCS.md`).
- When adjusting container mappings or defaults, rebuild the add-on (`ha addons build arm`) and restart it to confirm runtime behavior.
- Update `CHANGELOG.md` inside `arm/` to record user-visible changes before preparing a release.