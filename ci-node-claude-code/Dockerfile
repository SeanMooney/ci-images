# Claude Code CI Container Image
# Extends the base ci-test-node-debian-13 image with Node.js LTS and Claude Code CLI
# Uses official NodeSource repository for Node.js LTS and npm for Claude Code installation
#
# Dependencies (provided by parent image):
# - curl: Download NodeSource setup script
# - ca-certificates: Verify HTTPS connections
# - apt package manager: Install Node.js and dependencies
FROM ghcr.io/seanmooney/ci-test-node-debian-13:latest

# Switch to root user to install Node.js system-wide
USER root

# Install Node.js LTS using official NodeSource repository
# Install curl and gnupg for repository setup if not already present
RUN apt-get update && \
    apt-get install -y curl gnupg && \
    # Add NodeSource repository for Node.js LTS (20.x)
    curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - && \
    # Install Node.js (includes npm)
    apt-get install -y nodejs && \
    # Clean up apt caches to reduce image size
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Switch to zuul user for Claude Code installation
USER zuul

# Set working directory to zuul's home directory
WORKDIR /home/zuul

# Verify Node.js and npm installation
RUN node --version && npm --version

# Configure npm global directory for zuul user
# This ensures npm global packages are installed in zuul's home directory
RUN npm config set prefix '~/.npm-global'

# Install Claude Code globally via npm
RUN npm install -g @anthropic-ai/claude-code

# Add npm global bin to PATH for claude access
ENV PATH="/home/zuul/.npm-global/bin:${PATH}"

# Verify Claude Code installation and confirm image build
RUN claude --version && \
    echo "Claude Code CI image build confirmed successfully"

# Entrypoint inherited from parent image (starts SSH daemon)