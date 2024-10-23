FROM nvcr.io/nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

# Install FFMPEG
RUN apt-get update && apt-get install -y ffmpeg python3-pip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Google Cloud CLI
RUN apt-get update && apt-get install -y curl gnupg \
    && curl -sSL https://sdk.cloud.google.com | bash \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Python dependencies
RUN pip install --upgrade pip --no-cache-dir
RUN pip install torch==2.4.1 torchvision==0.19.1 torchaudio==2.4.1 --index-url https://download.pytorch.org/whl/cu124 --no-cache-dir
RUN pip install insanely-fast-whisper --no-cache-dir

# Install flash-attn wheel
RUN pip install https://github.com/Dao-AILab/flash-attention/releases/download/v2.6.3/flash_attn-2.6.3+cu123torch2.4cxx11abiFALSE-cp310-cp310-linux_x86_64.whl --no-cache-dir

# Create workspace directory
WORKDIR /workspace

# Copy the source test files
COPY churchill.mp3 /workspace/churchill.mp3

# Run the transcription
ENTRYPOINT ["insanely-fast-whisper", "--file-name", "churchill.mp3", "--transcript-path", "churchill-v3-large.json", "--flash", "True", "--batch", "48"]