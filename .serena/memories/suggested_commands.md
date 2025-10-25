# Common Commands

## Git Operations
```bash
# Commit changes
git add [files]
git commit -m "message"
git push

# Create version tag and release
git tag -a vX.Y.Z -m "Release version X.Y.Z - Description"
git push origin vX.Y.Z

# View recent history
git log --oneline -10

# Check status
git status
```

## Version Release Workflow
```bash
# 1. Update version in config.yaml (manually or with sed)
sed -i '' 's/version: "0.1.8"/version: "0.1.9"/' arm/config.yaml

# 2. Commit and push version bump
git add arm/config.yaml
git commit -m "Bump version to 0.1.9"
git push

# 3. Create and push tag
git tag -a v0.1.9 -m "Release version 0.1.9 - Brief description"
git push origin v0.1.9
```

## Docker Development
```bash
# Build image locally
docker build -f .docker/Dockerfile -t test-arm .

# Run container for testing
docker run -p 8089:8081 -v ./test-config:/etc/arm/config test-arm

# Check logs
docker logs [container-id]

# Inspect container
docker inspect [container-id]
```

## Testing in Container
```bash
# Enter running container
docker exec -it [container-id] /bin/bash

# Test web service internally
curl http://localhost:8081
curl http://172.30.33.11:8081

# Check files
ls -la /etc/arm/config/
cat /etc/arm/config/arm.yaml
```

## Home Assistant Add-on Management
```bash
# Reload add-on repository (if using dev environment)
ha addons reload

# Build add-on locally
ha addons build arm

# Restart add-on
ha addons restart arm

# View add-on logs
ha addons logs arm
```

## File Operations
```bash
# List directory structure
tree arm/

# Find files
find arm/ -name "*.yaml"

# Check file permissions
ls -la arm/rootfs/run.sh

# Make script executable
chmod +x arm/rootfs/run.sh
```

## Checking Workflow Status
- Visit: https://github.com/mliradelc/ARM-HASS-Addon/actions
- Check if builds completed successfully
- Verify images pushed to GHCR: https://github.com/mliradelc/ARM-HASS-Addon/pkgs/container/arm-hass-addon
