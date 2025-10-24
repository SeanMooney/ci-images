# Zuul CI Test Node Images

Custom container images for Zuul CI testing with SSH server, Python, and Ansible runtime requirements pre-installed.

## Repository Structure

```
ci-images/
├── .github/workflows/
│   └── build-and-push.yml     # GitHub Actions CI/CD pipeline
├── ubuntu-24.04/
│   ├── Dockerfile             # Ubuntu 24.04 image definition
│   └── entrypoint.sh          # SSH key injection script
├── debian-13/
│   ├── Dockerfile             # Debian 13 image definition
│   └── entrypoint.sh          # SSH key injection script
├── ci-node-opencode/
│   ├── Dockerfile             # OpenCode-enabled image definition
│   └── entrypoint.sh          # SSH key injection script with NVM
├── AGENTS.md                  # Guidelines for coding agents
└── README.md                  # This file
```

## Available Images

All images are available from GitHub Container Registry:

| Image | Base OS | Size | Use Case |
|-------|---------|------|----------|
| **Ubuntu 24.04** | `ghcr.io/seanmooney/ci-test-node-ubuntu-24.04:latest` | ~450MB | Modern Ubuntu with latest packages |
| **Debian 13** | `ghcr.io/seanmooney/ci-test-node-debian-13:latest` | ~420MB | Minimal stable base, smaller footprint |
| **CI Node OpenCode** | `ghcr.io/seanmooney/ci-node-opencode:latest` | ~550MB | Debian 13 + Node.js LTS + OpenCode AI |

## Features

✅ **SSH Server** - OpenSSH server pre-configured for key-based authentication  
✅ **Python 3** - Python 3 with pip, apt, and dev packages  
✅ **POSIX Tools** - Standard Unix utilities for CI workflows  
✅ **Build Tools** - build-essential for compiling software  
✅ **Zuul User** - Pre-configured `zuul` user with sudo access  
✅ **Ansible Ready** - All dependencies for Ansible playbook execution
✅ **Node.js LTS** - Latest Node.js Long Term Support with NVM
✅ **OpenCode AI** - AI-powered coding assistant pre-installed

## Installed Packages

### Common Packages (All Images)
- openssh-server
- python3, python3-pip, python3-apt, python3-dev
- sudo, git, curl, wget
- ca-certificates, gnupg, lsb-release
- build-essential
- iproute2
- python3-boto3

### Ubuntu 24.04 Specific
- software-properties-common (Ubuntu PPA support)

### CI Node OpenCode Specific
- Node.js LTS (via NVM)
- opencode-ai (global npm package)
- curl (for NVM installation)

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
  - name: debian-13-pod
    type: pod
    python-path: /usr/bin/python3
    cpu: 2
    memory: 2048
    spec:
      containers:
        - name: debian-13-pod
          image: ghcr.io/seanmooney/ci-test-node-debian-13:latest
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

### CI Node OpenCode with OpenCode AI

```yaml
labels:
  - name: ci-node-opencode
    type: pod
    python-path: /usr/bin/python3
    cpu: 2
    memory: 4096  # More memory for Node.js and AI operations
    spec:
      containers:
        - name: ci-node-opencode
          image: ghcr.io/seanmooney/ci-node-opencode:latest
          imagePullPolicy: Always
          env:
            - name: SSH_AUTHORIZED_KEYS
              valueFrom:
                secretKeyRef:
                  name: zuul-executor-pubkey
                  key: pubkey
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

# Build Debian 13 image
cd ../debian-13
docker build -t ci-test-node-debian-13 .

# Build CI Node OpenCode image
cd ../ci-node-opencode
docker build -t ci-node-opencode .
```

## Testing Locally

```bash
# Start container with SSH key
docker run -d -p 2222:22 \
  -e SSH_AUTHORIZED_KEYS="$(cat ~/.ssh/id_ed25519.pub)" \
  ghcr.io/seanmooney/ci-test-node-ubuntu-24.04:latest

# Connect via SSH
ssh -p 2222 zuul@localhost

# Test CI Node OpenCode with OpenCode AI
docker run -d -p 2223:22 \
  -e SSH_AUTHORIZED_KEYS="$(cat ~/.ssh/id_ed25519.pub)" \
  ghcr.io/seanmooney/ci-node-opencode:latest

# Connect via SSH and test OpenCode
ssh -p 2223 zuul@localhost
opencode --help
```

## Automated Builds

Images are automatically built and pushed to GitHub Container Registry when changes are pushed to the `master` branch via GitHub Actions.

**Build Triggers:**
- Changes to `ubuntu-24.04/**` → builds Ubuntu 24.04 image
- Changes to `debian-13/**` → builds Debian 13 image
- Changes to `ci-node-opencode/**` → builds CI Node OpenCode image
- Changes to `.github/workflows/build-and-push.yml` → triggers all builds

## License

MIT License

## Contributing

Pull requests welcome! Please ensure Dockerfiles follow best practices and test changes before submitting.
