FROM ubuntu:22.04

# Install system packages
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    # SSH server
    openssh-server \
    # Python and dependencies
    python3 \
    python3-pip \
    python3-apt \
    python3-dev \
    # Ansible runtime requirements
    sudo \
    git \
    curl \
    wget \
    # POSIX tools
    ca-certificates \
    gnupg \
    lsb-release \
    software-properties-common \
    # Build tools (often needed for CI)
    build-essential \
    # Network tools (needed for validate-host role)
    iproute2 \
    # Python packages for S3 uploads
    python3-boto3 \
    # Clean up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Create zuul user for job execution
RUN useradd -m -s /bin/bash -u 1000 zuul && \
    echo "zuul ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/zuul && \
    chmod 0440 /etc/sudoers.d/zuul

# Configure SSH
RUN mkdir -p /run/sshd && \
    mkdir -p /home/zuul/.ssh && \
    chmod 700 /home/zuul/.ssh && \
    chown -R zuul:zuul /home/zuul/.ssh

# SSH server configuration
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin no/' /etc/ssh/sshd_config && \
    sed -i 's/#PubkeyAuthentication yes/PubkeyAuthentication yes/' /etc/ssh/sshd_config && \
    sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config && \
    sed -i 's/#PermitEmptyPasswords no/PermitEmptyPasswords no/' /etc/ssh/sshd_config

# Expose SSH port
EXPOSE 22

# Copy entrypoint script
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
