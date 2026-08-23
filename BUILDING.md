# Building

Build and publish multiarch image.

## Local Build

```bash
docker build -t opensim-simulator:local .
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
