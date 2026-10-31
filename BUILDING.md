# Building

Build and publish multiarch image.

## Local Build

```bash
docker build -t opensim-simulator:local .
```

Note: this default command builds the final Dockerfile stage (`release-runtime`), which uses `OPENSIM_RELEASE_URL` (official release archive).

To build from source (using `OPENSIM_GIT_URL` / your fork defaults), target the source runtime stage explicitly:

```bash
docker build --target source-runtime -t opensim-simulator:local-source .
```

### Run Local

```bash
docker run --rm \
  -p 9000:9000 \
  -v ./examples/standalone:/config \
  opensim-simulator:local
```

## Publish

### Setup

Create/use a buildx builder once:

```bash
docker buildx create --name multiarch --use
docker buildx inspect --bootstrap
```

### Build

Build and push Linux AMD64 + ARM64:

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t bithatch/opensim-simulator \
  -t bithatch/opensim-simulator:$(date +%Y%m%d) \
  --push \
  .
```

## Automated Publish (GitHub Actions)

This repository now includes `.github/workflows/docker-publish.yml` to automatically build and push a multiarch image to Docker Hub.

### Triggers

- Pushes to `master` or `main` when `Dockerfile`, `docker/**`, or the workflow itself changes
- Git tags matching `v*`
- Manual `workflow_dispatch`

### Required Repository Secrets

- `DOCKERHUB_USERNAME`: Docker Hub username or org robot account name
- `DOCKERHUB_TOKEN`: Docker Hub access token (recommended) or password

### Published Platforms and Tags

- Platforms: `linux/amd64`, `linux/arm64`
- Tags (default branch): `latest`, `YYYYMMDD`, and `sha-<commit>`
- Tags (tag builds): `<git-tag>` and `sha-<commit>`
