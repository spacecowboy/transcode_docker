FROM ubuntu:25.04

ARG UID=1000
ARG GID=1000

# Update and install required packages
RUN apt-get update && apt-get install -y \
    handbrake-cli \
    ffmpeg \
    ruby \
    git \
    ca-certificates \
    --no-install-recommends \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create output directory and app directory
RUN mkdir -p /output && mkdir -p /app

# Clone the latest version of the video_transcoding scripts
RUN git clone --depth 1 https://github.com/lisamelton/video_transcoding.git /tmp/video_transcoding \
    && cp /tmp/video_transcoding/*.rb /app/ \
    && rm -rf /tmp/video_transcoding \
    && chmod +x /app/*.rb \
    && chown -R ${UID}:${GID} /output /app

# Switch to non-root user specified by UID/GID
USER ${UID}:${GID}

# Set working directory to output directory
WORKDIR /output

# Set the entrypoint to the transcode-video.rb script
ENTRYPOINT ["/app/transcode-video.rb"]

# Default command (can be overridden at runtime)
CMD []
