# Zuul CI Test Node Images

Custom container images for Zuul CI testing with SSH server, Python, and Ansible runtime requirements pre-installed.

## Available Images

All images are available from GitHub Container Registry:

- **Ubuntu 24.04**: `ghcr.io/seanmooney/ci-test-node-ubuntu-24.04:latest`
- **Ubuntu 22.04**: `ghcr.io/seanmooney/ci-test-node-ubuntu-22.04:latest`
- **Debian 13**: `ghcr.io/seanmooney/ci-test-node-debian-13:latest`

## Features

✅ **SSH Server** - OpenSSH server pre-configured for key-based authentication
✅ **Python 3** - Python 3 with pip, apt, and dev packages
✅ **POSIX Tools** - Standard Unix utilities for CI workflows
✅ **Build Tools** - build-essential for compiling software
✅ **Zuul User** - Pre-configured `zuul` user with sudo access
✅ **Ansible Ready** - All dependencies for Ansible playbook execution

## Installed Packages

- openssh-server
- python3, python3-pip, python3-apt, python3-dev
- sudo, git, curl, wget
- ca-certificates, gnupg, lsb-release, software-properties-common
- build-essential

## Usage with Zuul Nodepool

### SSH Key Injection via Environment Variable

```yaml
labels:
  - name: ubuntu-24-04-pod
    type: pod
    python-path: /usr/bin/python3
    cpu: 2
    memory: 2048
    spec:
      containers:
        - name: ubuntu-24-04-pod
          image: ghcr.io/seanmooney/ci-test-node-ubuntu-24.04:latest
          imagePullPolicy: Always
          env:
            - name: SSH_AUTHORIZED_KEYS
              valueFrom:
                secretKeyRef:
                  name: zuul-executor-pubkey
                  key: pubkey
```

### SSH Key Injection via Volume Mount

```yaml
labels:
  - name: ubuntu-24-04-pod
    type: pod
    python-path: /usr/bin/python3
    cpu: 2
    memory: 2048
    spec:
      containers:
        - name: ubuntu-24-04-pod
          image: ghcr.io/seanmooney/ci-test-node-ubuntu-24.04:latest
          imagePullPolicy: Always
          volumeMounts:
            - name: ssh-keys
              mountPath: /ssh-keys
              readOnly: true
      volumes:
        - name: ssh-keys
          secret:
            secretName: zuul-executor-pubkey
            items:
              - key: pubkey
                path: authorized_keys
```

## User Configuration

- **Username**: `zuul`
- **UID**: 1000
- **Shell**: /bin/bash
- **Sudo**: Password-less sudo enabled
- **SSH**: Public key authentication only

## Building Locally

```bash
# Clone the repository
git clone https://github.com/SeanMooney/ci-images.git
cd ci-images

# Build Ubuntu 24.04 image
cd ubuntu-24.04
docker build -t ci-test-node-ubuntu-24.04 .

# Build Ubuntu 22.04 image
cd ../ubuntu-22.04
docker build -t ci-test-node-ubuntu-22.04 .

# Build Debian 13 image
cd ../debian-13
docker build -t ci-test-node-debian-13 .
```

## Testing Locally

```bash
# Start container with SSH key
docker run -d -p 2222:22 \
  -e SSH_AUTHORIZED_KEYS="$(cat ~/.ssh/id_ed25519.pub)" \
  ghcr.io/seanmooney/ci-test-node-ubuntu-24.04:latest

# Connect via SSH
ssh -p 2222 zuul@localhost
```

## Automated Builds

Images are automatically built and pushed to GitHub Container Registry when changes are pushed to the `main` branch via GitHub Actions.

See `.github/workflows/build-and-push.yml` for the workflow configuration.

## License

MIT License

## Contributing

Pull requests welcome! Please ensure Dockerfiles follow best practices and test changes before submitting.
