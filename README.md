# Video Transcoding Docker Container

This Docker container wraps [Lisa Melton's video_transcoding](https://github.com/lisamelton/video_transcoding) Ruby scripts for easy use without having to install dependencies directly on your system. The container automatically fetches the latest version of the scripts during build time.

## Building the Container

Build the Docker container from the Dockerfile:

```bash
docker build -t transcode-video .
```

You can specify custom UID and GID values if needed (defaults to 1000:1000):

```bash
docker build --build-arg UID=$(id -u) --build-arg GID=$(id -g) -t transcode-video .
```

## Basic Usage

The container uses `transcode-video.rb` as its entrypoint, so you can pass arguments directly to `docker run`. Output files will be written to `/output` in the container by default.

```bash
docker run -v /path/to/your/media:/mnt/media -v $(pwd):/output transcode-video [OPTIONS] /mnt/media/video.mkv
```

## Mount Points and Volume Mapping

The container requires two important volume mounts:

1. **Input Media**: Mount the directory containing your source video files to a location inside the container (like `/mnt/media`)
2. **Output Directory**: Mount a directory where you want the transcoded files to be saved to `/output` in the container

## Common Usage Patterns

### Basic H.264 Encoding

`h264` is the default mode.

```bash
docker run -v /path/to/media:/mnt/media -v $(pwd):/output transcode-video \
  --mode h264 /mnt/media/video.mkv
```

### H.265/HEVC Encoding

```bash
docker run -v /path/to/media:/mnt/media -v $(pwd):/output transcode-video \
  --mode hevc /mnt/media/video.mkv
```

### Including All Audio and Subtitle Tracks

```bash
docker run -v /path/to/media:/mnt/media -v $(pwd):/output transcode-video \
  --mode h264 --add-audio all --add-subtitle all /mnt/media/video.mkv
```


### Using detect-crop.rb

```bash
docker run -v /path/to/media:/mnt/media -v $(pwd):/output --entrypoint /app/detect-crop.rb \
  /mnt/media/video.mkv
```

### Using convert-video.rb

```bash
docker run -v /path/to/media:/mnt/media -v $(pwd):/output --entrypoint /app/convert-video.rb \
  /mnt/media/video.mp4
```

## File Permissions

The container runs with the UID/GID specified during build (defaults to 1000:1000). The output files will have these ownership values. If you need different permissions, either:

1. Build the container with custom UID/GID values
2. Change permissions on the output files after transcoding

## Troubleshooting

If you encounter permissions issues:
- Ensure the UID/GID values match your user on the host system
- Check that your mounted directories have appropriate permissions

If the container exits immediately:
- Verify that the input file path is correct
- Check that all required volumes are properly mounted

## Available Scripts

This container includes the following scripts from Lisa Melton's video_transcoding project:

- `transcode-video.rb` (default entrypoint) - Main transcoding script
- `detect-crop.rb` - Detect crop values for a video file
- `convert-video.rb` - Convert video file formats

To use a script other than the default `transcode-video.rb`, specify it with the `--entrypoint` flag as shown in the examples above.
