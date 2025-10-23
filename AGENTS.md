# CI Images Repository Guidelines

## Build Commands
```bash
# Build specific image locally
cd ubuntu-24.04 && docker build -t ci-test-node-ubuntu-24.04 .
cd debian-13 && docker build -t ci-test-node-debian-13 .

# Test container locally
docker run -d -p 2222:22 -e SSH_AUTHORIZED_KEYS="$(cat ~/.ssh/id_ed25519.pub)" ghcr.io/seanmooney/ci-test-node-ubuntu-24.04:latest
ssh -p 2222 zuul@localhost
```

## Code Style Guidelines
- **Dockerfiles**: Use Ubuntu/Debian official base images, chain RUN commands with &&, clean apt caches
- **Shell scripts**: Use `#!/bin/bash`, `set -e`, proper error handling, quote variables
- **File structure**: Each OS has its own directory with Dockerfile and entrypoint.sh
- **Security**: Disable password auth, use key-based SSH only, create zuul user with sudo
- **Naming**: Use kebab-case for image names, consistent with directory structure
- **No tests**: This is a container image repo - validate by building and running containers

## Repository Structure
- Images trigger builds on paths: `ubuntu-24.04/**`, `debian-13/**`
- All images push to `ghcr.io/seanmooney/ci-test-node-*` with SHA and latest tags
- Entry points handle SSH key injection via env var or volume mount

## Optimization Guidelines
- Use `--no-install-recommends` for apt-get installs
- Consolidate RUN commands to reduce layers
- Consider multi-stage builds for size reduction
- Add USER zuul instruction after setup
- Use specific base image tags for reproducibility
