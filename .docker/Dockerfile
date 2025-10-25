FROM docker.io/1337server/automatic-ripping-machine:latest

WORKDIR /

# Run handbrake install
RUN chmod +x /install_handbrake.sh
RUN ./install_handbrake.sh

# Copy default config files
COPY arm/rootfs/defaults /defaults

# Copy startup script
COPY arm/rootfs/run.sh /run.sh
RUN chmod +x /run.sh

# Override entrypoint to run our script
ENTRYPOINT ["/run.sh"]
