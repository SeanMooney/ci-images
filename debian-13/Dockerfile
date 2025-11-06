FROM debian:13

# Create zuul user and configure SSH in single layer for efficiency
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    # SSH server
    openssh-server \
    # Python and dependencies
    python3 \
    python3-pip \
    python3-apt \
    python3-dev \
    python3.13-venv \
    # Ansible runtime requirements
    sudo \
    git \
    curl \
    wget \
    # POSIX tools
    nano \
    tree \
    less \
    ca-certificates \
    gnupg \
    lsb-release \
    # Build tools (often needed for CI)
    build-essential \
    # Archive tools
    unzip \
    rsync \
    # Network tools (needed for validate-host role)
    iproute2 \
    # Access Control List utilities
    acl \
    # Python packages for S3 uploads
    python3-boto3 \
    # Create zuul user for job execution
    && useradd -m -s /bin/bash -u 1000 zuul \
    && echo "zuul ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/zuul \
    && chmod 0440 /etc/sudoers.d/zuul \
    # Configure SSH directories and permissions
    && mkdir -p /run/sshd \
    && mkdir -p /home/zuul/.ssh \
    && chmod 700 /home/zuul/.ssh \
    && chown -R zuul:zuul /home/zuul/.ssh \
    # SSH server configuration
    && sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config \
    && sed -i 's/^#*PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config \
    && sed -i 's/^#*PermitEmptyPasswords.*/PermitEmptyPasswords no/' /etc/ssh/sshd_config \
    # Uncomment and enable all host key types
    && sed -i 's/^#*HostKey \/etc\/ssh\/ssh_host_rsa_key/HostKey \/etc\/ssh\/ssh_host_rsa_key/' /etc/ssh/sshd_config \
    && sed -i 's/^#*HostKey \/etc\/ssh\/ssh_host_ecdsa_key/HostKey \/etc\/ssh\/ssh_host_ecdsa_key/' /etc/ssh/sshd_config \
    && sed -i 's/^#*HostKey \/etc\/ssh\/ssh_host_ed25519_key/HostKey \/etc\/ssh\/ssh_host_ed25519_key/' /etc/ssh/sshd_config \
    # Clean up
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Set working directory to zuul's home directory
WORKDIR /home/zuul

# Switch to zuul user for security
USER zuul

# Expose SSH port
EXPOSE 22

# Add health check for SSH service
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD pgrep sshd > /dev/null || exit 1

# Copy entrypoint script and set permissions
COPY --chown=zuul:zuul entrypoint.sh /entrypoint.sh
USER root
RUN chmod +x /entrypoint.sh
USER zuul

ENTRYPOINT ["/entrypoint.sh"]
