# OpenCode CI Container Image
# Extends the base ci-test-node-debian-13 image with SST OpenCode CLI
# Uses standalone binary installation (no Node.js dependency required)
#
# Dependencies (provided by parent image):
# - curl: Download the install script and binary
# - ca-certificates: Verify HTTPS connections
# - unzip: Extract the downloaded OpenCode archive
FROM ghcr.io/seanmooney/ci-test-node-debian-13:latest

# Switch to zuul user for OpenCode installation
USER zuul

# Set working directory to zuul's home (required by install script)
WORKDIR /home/zuul

# Install OpenCode using the official install script
# The script:
# - Downloads the latest OpenCode standalone binary (currently v0.15.16)
# - Installs to ~/.opencode/bin/opencode
# - Automatically adds PATH configuration to ~/.bashrc for SSH sessions
RUN curl -fsSL https://opencode.ai/install | bash

# Add OpenCode to PATH for non-interactive shells and direct execution
# Note: .bashrc is already configured by the install script for interactive/SSH sessions
ENV PATH="/home/zuul/.opencode/bin:${PATH}"

# Entrypoint inherited from parent image (starts SSH daemon)
