# Style Guidelines

## Shell Scripts (run.sh)
- Use `#!/bin/bash` shebang
- Start with `set -e` for error handling
- Use descriptive echo messages with `[INFO]`, `[ERROR]` prefixes
- Check file existence before operations: `if [ ! -f "/path/file" ]; then`
- Set permissions explicitly after copying: `chmod 644`
- Use `exec` for final command to replace shell process
- Specify interpreters explicitly: `exec python3 script.py`

## YAML Configuration
- Use 2-space indentation
- Keep sections organized: metadata, runtime, ports, devices, mapping
- Add comments for complex or non-obvious settings
- Use descriptive keys in `ports_description`
- Follow Home Assistant add-on schema strictly

## Docker/Container
- Copy files in logical groups
- Set working directory explicitly
- Use `RUN chmod +x` for scripts
- Override entrypoint when needed
- Don't expose ports in Dockerfile (handled by config.yaml)

## Git Commit Messages
- Use present tense: "Fix X" not "Fixed X"
- Be descriptive: "Fix watchdog to use 0.0.0.0 binding"
- Prefix with type when appropriate: "Fix:", "Add:", "Update:"
- Reference version in tag messages: "Release version X.Y.Z - Description"

## Versioning
- Follow semantic versioning: MAJOR.MINOR.PATCH
- Keep version in config.yaml synchronized with git tags
- Current series: 0.1.x (pre-1.0 development)
- Increment PATCH for bug fixes and config changes
- Increment MINOR for new features

## Documentation
- Keep README.md updated with current features
- Document hardware requirements clearly
- Include example configurations
- Note any known limitations or issues
