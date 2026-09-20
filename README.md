# OpenSimulator Docker Image

[![OpenSimulator](https://img.shields.io/badge/Docker%20Hub-bithatch%2Fopensim--simulator-blue?logo=docker&logoColor=white)](https://hub.docker.com/r/bithatch/opensim-simulator)
[![Docker Publish](https://github.com/opensim-stack/opensim-simulator/actions/workflows/docker-publish.yml/badge.svg)](https://github.com/opensim-stack/opensim-simulator/actions/workflows/docker-publish.yml)

A Docker image for [OpenSimulator](http://opensimulator.org/), built specifically for [OpenSim AI Stack](https://opensim-stack.github.io), but other use-cases are possible.

## Purpose

This image will be used to start both *Robust* services and *Simulator* instances, depending on configuration.  

## Usage

Prepare configuration in a directory, e.g A Standalone server with a SQLite database.

```
 my-config
    |
    |\___ OpenSim.ini
    |\___ startup_commands.txt    # optional
    |\___ shutdown_commands.txt    # optional
    |\___ Regions
    |      \__ Region.ini
     \___ config-include
            |\__ Standalone.ini
            |\__ StandaloneCommon.ini
            |\__ FloatsamCache.ini
             \__ storage
                    \__SQLiteStandalone.ini
```

Run the container.

```bash
docker run --rm \
  -p 9000:9000 \
  -v examples/standalone:/config \
  -v logs:/logs \
  -v workspace:/workspace \
  bithatch/opensim-simulator:latest
```

Map that to `/config` when starting the container.

The image will start the specified OpenSimulator version after symlinking the primary configuration files to `/config`. 

This allows the container to be pre-configured in one location.

## Variables

There are a number of variables to affect behaviour.

| Name | Default | Description |
| ---- | ------- | ----------- |
| `CONFIG_DIR` | `/config` | Location of override configuration files |
| `LOG_DIR` | `/logs` | Location of log files |
| `OPENSIM_SERVER_DLL` | `OpenSim.dll` | Server DLL to start |
| `OPENSIM_GIT_REF` | `master` | Git Branch to get for source build |
| `OPENSIM_RELEASE_REF` | `r58b7b39 ` | Release reference for release build |
| `OPENSIM_RELEASE_URL` | `https://github.com/opensim/opensim/releases/download/${OPENSIM_RELEASE_REF}/LastDotNetBuild.zip` | Full URL of release download |
