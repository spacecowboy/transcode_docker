FROM ubuntu:25.04

ARG UID=1000
ARG GID=1000

# Update and install required packages
RUN apt-get update && apt-get install -y \
    handbrake-cli \
    ffmpeg \
    ruby \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create output directory and app directory
RUN mkdir -p /output && mkdir -p /app && chown ${UID}:${GID} /output /app

# Copy the Ruby scripts
COPY *.rb /app/

# Set executable permissions
RUN chmod +x /app/*.rb

# Switch to non-root user specified by UID/GID
USER ${UID}:${GID}

# Set working directory to output directory
WORKDIR /output

# Set the entrypoint to the transcode-video.rb script
ENTRYPOINT ["/app/transcode-video.rb"]

# Default command (can be overridden at runtime)
CMD []
