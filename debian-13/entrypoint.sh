#!/bin/bash
set -e

# If SSH_AUTHORIZED_KEYS environment variable is set, use it
if [ -n "$SSH_AUTHORIZED_KEYS" ]; then
    echo "$SSH_AUTHORIZED_KEYS" > /home/zuul/.ssh/authorized_keys
    chown zuul:zuul /home/zuul/.ssh/authorized_keys
    chmod 600 /home/zuul/.ssh/authorized_keys
fi

# If authorized_keys file is mounted as a volume, use it
if [ -f /ssh-keys/authorized_keys ]; then
    cp /ssh-keys/authorized_keys /home/zuul/.ssh/authorized_keys
    chown zuul:zuul /home/zuul/.ssh/authorized_keys
    chmod 600 /home/zuul/.ssh/authorized_keys
fi

# Generate host keys if they don't exist
ssh-keygen -A

# Start SSH daemon in foreground
exec /usr/sbin/sshd -D -e
