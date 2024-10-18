FROM nvcr.io/nvidia/pytorch:23.10-py3

# Install FFMPEG
RUN apt-get update && apt-get install -y ffmpeg

# Install Python dependencies
RUN pip install --upgrade pip --no-cache-dir
RUN pip install insanely-fast-whisper --no-cache-dir

# Create workspace directory
WORKDIR /workspace

# Copy the source test files
COPY churchill.mp3 /workspace/churchill.mp3

# Run the transcription
ENTRYPOINT ["insanely_fast_whisper", "--file-name", "churchill.mp3", "--transcript-path", "churchill-v3-large.json", "--flash", "True", "--batch", "72"]`