FROM docker.io/1337server/automatic-ripping-machine:latest

WORKDIR /

# Install network tools for healthcheck
RUN apt-get update && \
    apt-get install -y --no-install-recommends netcat-openbsd && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Run handbrake install
RUN chmod +x /install_handbrake.sh
RUN ./install_handbrake.sh

# Copy default config files
COPY arm/rootfs/defaults /defaults

# Copy startup script
COPY arm/rootfs/run.sh /run.sh
RUN chmod +x /run.sh

# Add healthcheck for ARM web UI on port 8089
# Use nc (netcat) to test if port 8089 is listening on the container's IP
# Check every 30s, timeout after 10s, start checking after 60s, allow 3 retries
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
  CMD nc -z 127.0.0.1 8089 || nc -z $(hostname -i) 8089 || exit 1

# Override entrypoint to run our script
ENTRYPOINT ["/run.sh"]
